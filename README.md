# Binary-Init-Client
The client counterpart to [Jenkins Binary Init](https://github.com/Adam-Lechnos/Jenkins-Binary-Init) tool. For DevOps/SRE testing to ensure client binary's match that of the pipeline's.

#### Description
Devops pipeline based binaries use devops tested and sanctioned versions of binaries which pipeline function are dependent upon, such as Terraform and Terragrunt. End-users end devops admins are encouraged to leverage this tool to ensure local binaries match the of the versions sanctioned for use in their devops pipeline counterparts. Ensuring consitent versioning between local and pipeline binaries, Terraform state files will remain consistent on the back-end.
 
#### Intended Audience
* Devops
* End-users

#### Pre-requisites
* Update Local Unix PATH
* Github Access Token
* No other comparable binaries available on the local host
* [binary-version.json](./binary-versions.json) file inside a seperate repository.
* Update the vars within the script with the full repo path in the following format:
  * TFvar for Terraform: https://raw.github.com/org/repo/${branch}/pipeline_files/binary_versions
  * TGvar for Terragrunt: https://raw.github.com/org/repo/${branch}/pipeline_files/binary_versions

#### Updating the local Unix PATH
The binary-init-cache folder is created inside the home folder during execution; all downloaded binaries are stored and maintained here.

* Execute the following command manually or update `.bashrc`
  * `export PATH=$HOME/binary-init-cache:$PATH`
    *  ensure `~/binary-init-cache` is listed first to ensure precedence

#### No Comparable Local Binaries
Ensure the binaries listed within the [binary-version.json](./binary-versions.json) file are not installed on the system, otherwise you run the risk of inadvertently executing incorrect versions of the software.

#### Usage
Arguments are based on position paramters
i.e., `binary-init-client <github access token> <account_config repo branch>`

##### Account_Config Repo Branch (Devops usage only)
###### :radioactive: When using this argument, you run the risk of updating back-end Terraform state files :radioactive:
Create a new branch if you intend on testing or using a diffent version of the binaries relative to what is listed inside the Main branch. Set the following file once the new branch is created: `pipeline_files/binary_versions`.

##### Options

* Github Access Token - first argument (required)
* Repo branch for the `binary-version.json` - second argument (defaults to Master if ommitted)
  * Use if testing different versions of binaries relative to the Master branch by creating a new branch within this repo

##### Examples

  * Use the test branch inside the account_config repo
    * `binary-init-client <access token> test`
  * Use/switch back to the default Master branch inside the account_config repo
    * `binary-init-client <access token>`
