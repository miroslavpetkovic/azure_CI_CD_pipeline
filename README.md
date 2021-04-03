# azure_CI_CD_pipline
![Python application test with Github Actions](https://github.com/StavrosD/Udacity-AzureDevOps-BuildingA_CI-CD_Pipeline/workflows/Python%20application%20test%20with%20Github%20Actions/badge.svg)

# Overview

In this project, I built this Github repository from scratch and I set up Continuous Integration and Continuous Delivery. I used Github Actions along with a Makefile, requirements.txt and application code to perform an initial lint, test, and install cycle.

I also integrated this project into Azure Pipelines in order to enable Continuous Delivery to Azure Web App Service.

![Project Architecture](./Screenshots/devops_architecture.svg)*Project Architecture*

## Project Plan

* [Trello board for the project](https://trello.com/b/uyi4JKGr/azure-devops-project-building-a-ci-cd-pipeline)
* [Spreadsheet that includes the original and final project plan](https://github.com/StavrosD/Udacity-AzureDevOps-BuildingA_CI-CD_Pipeline/raw/main/Yearly%20Project%20Management%20Plan.xlsx)

## Instructions


### How to use
#### 1. Prerequisites
Before trying to run the project, registration to the following websites is required:

* [Azure account](https://azure.microsoft.com/en-us/). You may also need a free [Microsoft outlook acccount](https://outlook.live.com/owa/)

* [Azure DevOps account](https://dev.azure.com/)

* [GitHub account](https://github.com/)

  
You should also install [Git](https://git-scm.com/downloads) on your local machine.

#### 2. Copy the repo to to your GitHub account.

You cannot run an application without a code, right?
You may download the application files to your computer and then upload them to your GitHub account but is not recommended.

An easier way to make a copy of a GitHub repository is by clicking the "Fork" button. However, this option is better for teamwork and it is not a good idea to share azure pipeline secrets in fork builds.

The best option for testing this project is cloning the repository.


Log into your GitHub account anc click "New" to create a new repository.
![New repository](./Screenshots/GithubNewRepo.png)

Enter the repository name. It must be unique in your account.
You may add a project description.
Check the "Azure pipelines" option and the click the "Create repository" button.

![Create new github repository](./Screenshots/GitHub-New.png)
If the "Azure pipelines" option is missing, install it via the [GitHub marketplace](https://github.com/marketplace/azure-pipelines). Choose the free service.

Then, clone the project:
* Open a terminal.
* Create a bare clone of the repository.
```
 git clone --bare https://github.com/StavrosD/Udacity-AzureDevOps-BuildingA_CI-CD_Pipeline.git
```
* Mirror-push to the new repository.
``` 
cd https://github.com/StavrosD/Udacity-AzureDevOps-BuildingA_CI-CD_Pipeline.git
git push --mirror https://github.com/your-GitHub-User-Name/your-repo-name.git
```
* Remove the temporary local repository you created earlier.
```
cd ..
rm -rf https://github.com/StavrosD/Udacity-AzureDevOps-BuildingA_CI-CD_Pipeline.git
```

#### 3. Configure GitHub Actions (CI)

GitHub Actions allow us to automate workflow. In this project we will use an action to test the code. 

You may skip creating GitHub Actions if you just want to run the ML app, the code is already tested.

A test should be already available because you cloned this repository. The Action file is inside the .github/workflows folder.

If you want to create an Action from scratch, all you have to do is to:

* Click on "Actions", under your GitHub repository name.
* Click "New Workflow"
* Click "Setup this workflow" under "Python application"
* Replace the file contents with the contents of the .github/workflows/pythonapp.yml file
* Click "Start commit"

#### 4. Configure Azure Pipelines (CD)

##### 4.1 Setup Azure Cloud Shell

If you have never set up the Azure Cloud Shell to clone GitHub repositories, you have to create sha1 keys and insert them on GitHub.

There are two ways to use the Azure Cloud Shell
* Select the Cloud Shell icon in the Azure Portal
![Azure Cloud Shell icon](./Screenshots/portal-launch-icon.png)

* Visit the [Azure Shell website](https://shell.azure.com/)

The first time you use the Azure Cloud Shell, you will be asked to create a storage resource. It is needed for peristing files.
You may find more information [here](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage)

Using the Azure Cloud Shell, create an rsa public/private key pair using the command:

```
ssh-keygen -t rsa
```
You will be asked for a passphrase. Please store the passphrase, you will need it any time you want to access the private key.

In your shell you should see the file where the key is stored. Display the key and copy it.
```
cat your-keyfile-path
```

You may setup SSH access for one project or for all projects. 
I will describe the process of setting up access to all projects. If you want to give SSH acces to a specific project, follow the process in the YouTube video (link on the bottom of this readme).
Now, use [GitHub Settings -> SSH and PGP keys](https://github.com/settings/keys) and click "New SSH key"

Enter a title and paste your sha key in the "Key" field.
Click "Add SSH key" to finish.
Now you can access your GitHub repositories from your Azure Cloud Shell.

##### 4.2 Clone your repository

First, go to your github repository to get the git link. Click the "Clone" button, select "SSH" and then click the "Copy" button nest to te git address.
![Copy git address](Screenshots/GitHub_clone.png)

In the Azure Cloud Shell, go to the folder where you want to clone the repository and clone it.

```
cd clouddrive
git clone paste_your_link.git
```

Only the first time you need to clone the repository. If you need to update it manually you should use the ``` git pull ``` command.

##### 4.3 Run the ML app

Go to your cloned repository and run the commannds.sh file.
Before running the file, replace `devopsCIDIproject` with your project name in the following files:
* commands.sh
* test_predict_azure_app.sh, if you want to make a prediction using the Azure Cloud Shell.
* test_prediction.py, if you want to make a prediction using the local terminal.
* locustfile.py, if you want to run the locust load test.

```
cd your-git-folder
./commands.sh
```
The application should be up and running. 
Run a test to verify it.
```
./make_predict_azure_app.sh
```
![Prediction](Screenshots/make_predict_azure_app.png)

##### 4.4 Configure Azure pipelines

Azure piplelines automate the deployment process. 
It is required to make a connection between Azure pipelines and GitHub.

* Sign in to [Azure DecOps](https://dev.azure.com/)
* Select "Create project"
* From the new project page, select Project settings from the left navigation
* On the Project Settings page, select Pipelines > Service connections, then select New service connection, and then select Azure Resource Manager from the dropdown
* In the "Add an Azure Resource Manager service connection" dialog box 
    * Enter a connection name
    * Scope level: Subscription
    * Select a resource group 
    * Check "Allow all pipelines to use this connection
* From your project page left navigation, select Pipelines
* Select New pipeline
* Select GitHub
* Select the repository that contains your app
* You may be redirected to GitHub. Click "Approve and Install"
* In the Configure your pipeline screen", select "Python to Linux Web App on Azure"
* On the top left of the screen, select your subscription and on the bottom right click "Continue"
* Select your web app name in the dropdown box, click "Validate and Configure"
* Click "Save and run"
* Click "Save and run" 

![Pipeline](./Screenshots/pipeline.png)

Now the pipeline is ready. Each time you update your repository, the pipeline will automatically pull the new version, it will try to build the application and if the build is successfull it will deploy it.

If you click on a pipeline you will see the commit history and an indicator if it was built and deployed sucessfully.
![Pipeline build and deploy history](Screenshots/PipelineHistory.png)

Then you can click on a commit and the build and deploy summary of this commit will be displayed:
![Pipeline commit summary](Screenshots/PipelineRunSummary.png)

You can also click on the build stage or deploy app to get detaile dstatus. It is useful for debugging in order to pinpoint a problem.
![Passing Azure pipelines testing](./Screenshots/AzurePassTests.png)


#### Screenshots

![Project cloned to Azure Cloud Shell](./Screenshots/CloneRepo.png)*Project cloned to Azure Cloud Shell*


![Project running on Azure App Service](Screenshots/AzureWebApp.png)*Project running on Azure App Service*


![Passing GitHub Actions testing](./Screenshots/GitHub-Action.png)*Passing GitHub Actions testing*


![Project pulled (manually updated) into Azure Cloud Shell](Screenshots/AzureCloud-GitHubPull.png)*Project cloned into Azure Cloud Shell*





![Passing tests that are displayed after running the `make all` command from the `Makefile`](./Screenshots/MakeAll.png)*Passing tests that are displayed after running the `make all` command from the `Makefile`*


![Output of streamed log files from deployed application](./Screenshots/WebApp-Log.png)*Output of streamed log files from deployed application*


![Load test using Locust](./Screenshots/LocustTest.png)*Load test using Locust - max @32RPS*

## Enhancements

This is a basic Azure DevOps project that demonstrates a CI/CD pipeline for testing and deploying a Machine Learning application.

Additional features should be taken into account in a commercial application,such as:

* Separate development and production environment
* Restricted permissions for the developers and the DevOps engineers.
* More tests
* Fault tolerant design
* Use a faster VM for the web app

## Demo 
[![Video walkthrough](http://img.youtube.com/vi/kD3T4xWTXlQ/0.jpg)](https://youtu.be/kD3T4xWTXlQ "Video walkthrough")
