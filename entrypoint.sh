#! /usr/bin/env bash

#----------------------------------------------------------------------------------------------------------------------------------------
cat > index-template.html <<EOF

<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <title>Test Results</title>
 <style type="text/css">
  BODY { font-family : monospace, sans-serif;  color: black;}
  P { font-family : monospace, sans-serif; color: black; margin:0px; padding: 0px;}
  A:visited { text-decoration : none; margin : 0px; padding : 0px;}
  A:link    { text-decoration : none; margin : 0px; padding : 0px;}
  A:hover   { text-decoration: underline; background-color : yellow; margin : 0px; padding : 0px;}
  A:active  { margin : 0px; padding : 0px;}
  .VERSION { font-size: small; font-family : arial, sans-serif; }
  .NORM  { color: black;  }
  .FIFO  { color: purple; }
  .CHAR  { color: yellow; }
  .DIR   { color: blue;   }
  .BLOCK { color: yellow; }
  .LINK  { color: aqua;   }
  .SOCK  { color: fuchsia;}
  .EXEC  { color: green;  }
 </style>
</head>
<body>
	<h1>Test Results</h1><p>
	<a href=".">.</a><br>

EOF


#----------------------------------------------------------------------------------------------------------------------------------------

mkdir -p ./${INPUT_RESULTS_HISTORY}

if [[ ${INPUT_REPORT_URL} != '' ]]; then
    AZ_WEBSITE_URL="${INPUT_REPORT_URL}"
fi


#----------------------------------------------------------------------------------------------------------------------------------------


cat index-template.html > ./${INPUT_RESULTS_HISTORY}/index.html

echo "├── <a href="./${INPUT_GITHUB_RUN_NUM}/index.html">Latest Test Results - RUN ID: ${INPUT_GITHUB_RUN_NUM}</a><br>" >> ./${INPUT_RESULTS_HISTORY}/index.html;
# sh -c "aws s3 ls s3://${AWS_S3_BUCKET}" |  grep "PRE" | sed 's/PRE //' | sed 's/.$//' | sort -nr | while read line;
#     do
#         echo "├── <a href="./"${line}"/">RUN ID: "${line}"</a><br>" >> ./${INPUT_RESULTS_HISTORY}/index.html; 
#     done;
echo "</html>" >> ./${INPUT_RESULTS_HISTORY}/index.html;
# cat ./${INPUT_RESULTS_HISTORY}/index.html


echo "copy test-results to ${INPUT_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
cp -R ./${INPUT_TEST_RESULTS}/. ./${INPUT_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}


#----------------------------------------------------------------------------------------------------------------------------------------


# Install Azcopy

# https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-a-script
echo "Setup AzCopy.."
mkdir -p tmp
cd tmp
wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
cp ./azcopy /usr/bin/
cd ..

# Check that azcopy command works from container
azcopy --version

#----------------------------------------------------------------------------------------------------------------------------------------

 
# Azure Blob Upload

sh -c "azcopy sync '${INPUT_RESULTS_HISTORY}' 'https://${INPUT_ACCOUNT_NAME}.blob.core.windows.net/${INPUT_CONTAINER}?${INPUT_SAS}' --recursive=true"

#----------------------------------------------------------------------------------------------------------------------------------------


# Azure Blob AzCopy List 

sh -c "azcopy list 'https://${INPUT_ACCOUNT_NAME}.blob.core.windows.net/${INPUT_CONTAINER}?${INPUT_SAS}' --output-type text" | grep "INFO:" | sed 's/INFO: //' | while read line; do awk -F '/' '{print $0}'; done;

#----------------------------------------------------------------------------------------------------------------------------------------

# # Delete history
# COUNT=$( sh -c "aws s3 ls s3://${AWS_S3_BUCKET}" | sort -n | grep "PRE" | wc -l )

# echo "count folders in results-history: ${COUNT}"
# echo "keep reports count ${INPUT_KEEP_REPORTS}"
# INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS+1))
# echo "if ${COUNT} > ${INPUT_KEEP_REPORTS}"
# if (( COUNT > INPUT_KEEP_REPORTS )); then
#   NUMBER_OF_FOLDERS_TO_DELETE=$((${COUNT}-${INPUT_KEEP_REPORTS}))
#   echo "remove old reports"
#   echo "number of folders to delete ${NUMBER_OF_FOLDERS_TO_DELETE}"
#   sh -c "aws s3 ls s3://${AWS_S3_BUCKET}" |  grep "PRE" | sed 's/PRE //' | sed 's/.$//' | head -n ${NUMBER_OF_FOLDERS_TO_DELETE} | sort -n | while read -r line;
#     do
#       sh -c "aws s3 rm s3://${AWS_S3_BUCKET}/${line}/ --recursive";
#       echo "deleted prefix folder : ${line}";
#     done;
# fi

