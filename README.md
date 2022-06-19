Example workflow file [html-reporter-azure-blob-website](https://github.com/PavanMudigonda/html-reporter-azure-blob-website/blob/main/.github/workflows/main.yml))

# HTML Test Results on AWS S3 Bucket with history action

## Usage

### `main.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)


#### The following example includes optimal defaults for a public static website:

```yaml
name: test-results

on:
  push:
    branches:
    - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Create Test Results History
        uses: PavanMudigonda/html-reporter-azure-blob-website@v0.1
        with:
          test_results: test-results
          results_history: results-history
          keep_reports: 20
          account_name: ${{ secrets.ACCOUNT_NAME }}
          container: ${{ secrets.CONTAINER }}
          SAS: ${{ secrets.SAS }}
```


### Configuration

### Inputs

This Action defines the following formal inputs.

| Name | Req | Description
|-|-|-|
| **`account_name`**  | true | Account Name is mandatory.
| **`container`** | true | Container name is mandatory.
|**`sas`** | true | SAS Token is Mandatory for Azure Storage.
|**`keep_reports`** | false | Defaults to 0. If you want this action to delete reports which are more than certian limit, then mention that limit.
|**`report_url`** | true | Specify your website URL. You could use Github Secrets.
|**`results_history`** | false | Defaults to results-history.
|**`test_results`** | false | Defaults to test-results. If your results are outputed to another folder, please specify.

    
### Outputs

This Action defines the following formal outputs.



### Azure Container Blob structure sample:- Organized by Github Run Number

Note:- Always the index.html points to Test Results History Page.

<img width="529" alt="image" src="https://user-images.githubusercontent.com/29324338/174486678-271f0cf2-e778-41cf-acc1-e4a119c01452.png">

### Azure Storage Blob Static Website Sample:- Full Report, Errors, Screenshots, Trace, Video is fully visible !

<img width="1228" alt="image" src="https://user-images.githubusercontent.com/29324338/174486693-39d875b5-3d82-47f6-85ca-69beae6666f5.png">
<img width="1193" alt="image" src="https://user-images.githubusercontent.com/29324338/174486699-bf783b17-9153-4234-8076-9d2de2e3f4e8.png">


