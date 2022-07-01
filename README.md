| **Reporter**        | **Github Pages**   | **Azure Storage Static Website** | **AWS S3 Static Website**                                                                    |
|---------------------|--------------------|-------------------------------|----------------------------------------------------------------------------------------------|
| **Allure HTML**     | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-github-pages) | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-azure-website)            | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-aws-s3-website )      |
| **Any HTML Reports** | [GH Action Link](https://github.com/marketplace/actions/html-reporter-github-pages) | [GH Action Link](https://github.com/marketplace/actions/html-reporter-azure-website)            | [GH Action Link](https://github.com/marketplace/actions/html-reporter-aws-s3-website) |


Example workflow file [html-reporter-azure-blob-website](https://github.com/PavanMudigonda/html-reporter-azure-website/blob/main/.github/workflows/main.yml))

# HTML Test Results on Azure Blob with history action

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
        uses: PavanMudigonda/html-reporter-azure-website@v1.0
        with:
          test_results: test-results
          results_history: results-history
          keep_reports: 20
          account_name: ${{ secrets.ACCOUNT_NAME }}
          container: ${{ secrets.CONTAINER }}
          SAS: ${{ secrets.SAS }}
```



## Also you can post link to the report to MS Teams
```yaml

- name: Message MS Teams Channel
  uses: toko-bifrost/ms-teams-deploy-card@master
  with:
    github-token: ${{ github.token }}
    webhook-uri: ${{ secrets.MS_TEAMS_WEBHOOK_URI }}
    custom-facts: |
      - name: Github Actions Test Results
        value: "http://example.com/${{ github.run_id }}"
    custom-actions: |
      - text: View CI Test Results
        url: "https://PavanMudigonda.github.io/html-reporter-github-pages/${{ github.run_number }}"
 ```
 
 ## Also you can post link to the report to MS Outlook
 
 ```yaml
 
 
 - name: Send mail
  uses: dawidd6/action-send-mail@v3
  with:
    # Required mail server address:
    server_address: smtp.gmail.com
    # Required mail server port:
    server_port: 465
    # Optional (recommended): mail server username:
    username: ${{secrets.MAIL_USERNAME}}
    # Optional (recommended) mail server password:
    password: ${{secrets.MAIL_PASSWORD}}
    # Required mail subject:
    subject: Github Actions job result
    # Required recipients' addresses:
    to: obiwan@example.com,yoda@example.com
    # Required sender full name (address can be skipped):
    from: Luke Skywalker # <user@example.com>
    # Optional whether this connection use TLS (default is true if server_port is 465)
    secure: true
    # Optional plain body:
    body: Build job of ${{github.repository}} completed successfully!
    # Optional HTML body read from file:
    html_body: file://README.html
    # Optional carbon copy recipients:
    cc: kyloren@example.com,leia@example.com
    # Optional blind carbon copy recipients:
    bcc: r2d2@example.com,hansolo@example.com
    # Optional recipient of the email response:
    reply_to: luke@example.com
    # Optional Message ID this message is replying to:
    in_reply_to: <random-luke@example.com>
    # Optional unsigned/invalid certificates allowance:
    ignore_cert: true
    # Optional converting Markdown to HTML (set content_type to text/html too):
    convert_markdown: true
    # Optional attachments:
    attachments: attachments.zip,git.diff,./dist/static/*.js
    # Optional priority: 'high', 'normal' (default) or 'low'
    priority: low
 ```
 
### Configuration

### Inputs

This Action defines the following formal inputs.

| Name | Req | Description
|-|-|-|
| **`account_name`**  | true | Azure Account Name is mandatory.
| **`container`** | true | Azure Container name is mandatory.
|**`sas`** | true | Azure Shared Access Signature (SAS) Token is Mandatory for Azure Storage.
|**`keep_reports`** | false | Defaults to 20. If you want this action to delete reports which are more than certian limit, then mention that limit.
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


