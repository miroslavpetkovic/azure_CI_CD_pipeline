# Overview

This project details steps for building a Github repository and creating an application scaffolding for a Machine Learning Flask Web App, to perform both continuous integration and continuous delivery. First by using Github Actions to perform an initial test and then integrating the application with Azure Pipelines to enable continuous delivery to Azure App Service. . 

## Project Plan
The first step is to create a project plan detailing what the tasks are, goals, deadlines, level of difficulty for each task, the person who is responsible for each task etc. This is essential for tracking tasks and making sure that each outlined task is completed in a timely manner in order to ensure completion of all tasks by the target completion date. 

* A link to a Trello board for this project
 https://trello.com/b/rBTAIP7Q/build-a-ci-cd-pipeline-project

* A link to a spreadsheet that includes the original and final project plan>
https://docs.google.com/spreadsheets/d/1qpCGKQe1nXdEB18FjAw5xvyuGp2dEQqrv6jw8nJYfxs/edit?usp=sharing

## Instructions
### Setting up the Azure Cloud Shell
  1. Create a Github Repo and initialize it with a READMe file and add a gitignore for python and ensure it is integrated with Azure Pipelines. 
  ![Create Repository](./screenshots/create_repository.PNG)
  
  2. Go to the Azure portal and open a terminal. 
  3. Create and activate a python virtual environment by running:
      `python3 -m venv~/.<yourreponame>`
       then
      `source ~/.<yourreponame>/bin/activate`
  4. Create an ssh key to communicate with Github by running:
      `ssh-keygen -t rsa`
  5. Open the .pub file using the cat command and copy the key in the file for example: 
      `cat </path>.ssh/id_rsa.pub`
  6. Go back to your github profile, under settings select SSH and GPG keys - paste the SSH key.
  7. Now you can do a git clone of the repo - hover over to your repo and click the code icon, select SSH and copy the SSH clone. 
  8. Go back to the Azure terminal and clone your repo by running
        `git clone<yoursshkey>`
      ![git_clone_create_venv](./screenshots/git_clone_create_venv.PNG)
      
      
   10. cd into your repo and you are ready for the next steps.
 
 ### Project Scaffolding - 
  The application scaffolding contains:
  * Makefile 
  * requirements.txt
  * python script (hello.py)
  * test file (hello_test.py)
    
  ### Local Continuous Integration setup
   1. First we need to do a local test to ensure that everything works. Once the scaffolding files are created, run `make all` on the azure terminal.
   2. This triggers the install, lint and test steps outlined in the makefile. (all the steps should pass)
   
   ![make all](./screenshots/make_all.PNG)
      

      
  #### Continuous Integration - Github Actions
  Ensure that you track all the changes to your github repo by running `git status`, `git add .`, `git commit -m "message"` and `git push`.
  In this step you will configure Github Actions to perform continuous integration remotely. this ensures that your code is continuously tested everytime new changes are 
      made to your repository depending on the series of commands you specify in the github actions config. 
  1. On the Github profile navigate to your repo and select Actions - choose 'set up yourself' option.
  2. This creates a yml code which you can edit yourself
  3. Push the changes to Github - navigate back to your repo , then select Actions again and the github workflow should now appear - click on it and select the yml file.
  4. Then click on 'build' and this should run to verify the lint and test steps pass.
    ![pythonapp_build](./screenshots/pythonapp_build.PNG)
    2. Get the code.
    1. In GitHub, [fork](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo) [this repository.](https://github.com/PaulNWms/udacity-cicd-pipeline)
    2. Click Code | SSH, then click the clipboard icon to copy your repo's SSH path.
    3. In the Azure Cloud Shell, clone your new repository with `git clone`  
    ![Clone Repo](images/Screenshot-clone-repo.png)

**Sanity check:** The code should download to a new folder without issues.

3. Set up a python virtual environment and activate it.  In this this example it's named 'cicd'.  
![venv](images/Screenshot-venv.png)

**Sanity check:** You should see the prompt change to reflect the virtual environment.

4. Build the project.
```bash
cd udacity-cicd-pipeline
make all
```
![venv](images/Screenshot-make-all.png)

**Sanity check:** The project should build without errors.

5. Run the microservice 'locally' (i.e. in the Cloud Shell).
![Service Running Locally](images/Screenshot-local-service.png)
Open a second console and run `curl localhost:5000`.  The microservice should respond with some HTML.
![Test service](images/Screenshot-curl.png)

**Sanity check:** Each time you run the `curl` command it should add another HTTP GET line to the output on the _main_ console, similar to the last line above.  

6. Deploy, run and test the microservice in Azure App Services.  
This will make it available over the internet.  Equally important, it will implicitly create a VM.  In a moment, this will become the target for the CD pipeline to deploy its content _to_.
    1. Back in the main Cloud Shell, `export FLASK_APP=app.py`, so flask knows what to run in the Azure App.
    2. Pick a name for your microservice.  This name will appear in the publicly available URL.
    3. Replace `<yourappname>` in `make_predict_azure_app.sh`
    4. Create the resource group and VM, upload the contents of the current directory and launch flask with `az webapp up`.  You will use the name for this command as well.  (here it's `udacity-flask-ml-service`)
    ![App Service](images/Screenshot-app-service1.png)
    ![App Service](images/Screenshot-app-service2.png)

**Sanity check(list):**  `az webapp up` did quite a few things behind the scenes, so there are a few things to check for
- The output contains the message `You can launch the app at ...`
- The output prints out JSON, and it contains the string `"sku": "FREE"`
- Hitting the website with `curl` produces the same HTML output it did in the previous step, when the service was run 'locally'.
- Running `./make_predict_azure_app.sh` responds with JSON.

7. In the second command window, tail the logs of the running Azure App with `azure webapp log tail`, e.g.

```bash
az webapp log tail --resource-group PaulWilliams_Redmond_rg_Linux_centralus -n udacity-flask-ml-service
```
**Sanity check:** Back in the main Cloud Shell, run `./make_predict_azure_app.sh`.  The request should be logged in the second Cloud Shell.
![](images/Screenshot-log-tail1.png)


8. **OPTIONAL** Set up GitHub Actions to build the project whenever changes are pushed to GitHub.  
This part is optional, but it's straightforward and can be disabled later.
    1. In GitHub, navigate to your project and click Actions.
    2. The project already has a GitHub Actions YAML file, so you should see this message:
    ![Enable Workflows](images/Screenshot-enable-workflows.png)
    Click the green button.  
    (apparently 'workflows' = GitHub Actions)  
    **Sanity check:** In the Azure Cloud Shell, edit this README.md, adding a few blank lines at the end.  Commit the changes in Git and push the repository to GitHub.  Now go back to GitHub.  The GitHub Action should have started, and it should succeed.  
    ![GitHub Action](images/Screenshot-github-action.png)

Note that you can disable the workflow at any time if you want to.
![Disable Workflow](images/Screenshot-disable-workflow.png)

9. Set up Azure Pipelines to build and deploy the project whenever changes are pushed to GitHub.  
This last step has several moving parts and specific details are subject to change.  If troubleshooting is necessary, please refer to the [official Azure Pipelines documents.](https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml)
    1. In GitHub, in the root folder of your repository there is a file called `azure-pipelines.yml`.  Delete this file and commit the changes.  (**Note to grader:** This file only exists for your benefit.)  When we run the wizard below, it will create a new `azure-pipelines.yml`, with the variables properly set for your configuration.
    2. Open up [Azure DevOps](https://dev.azure.com/).  If you don't have an existing organization you can use, you will need to set one up using [these instructions](https://docs.microsoft.com/en-us/azure/devops/user-guide/sign-up-invite-teammates?view=azure-devops).  
    (**Note to grader:** The remaining steps follow very closely the Microsoft documents on [pipeline setup](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops#create-an-azure-devops-project-and-connect-to-azure).  I was planning on referring the reader to this doc, but as of this writing the Microsoft help page is out of sync with the Azure Pipelines UI.  A few screens were borrowed from the Udacity instructions.)
    3. Create a new project.
    ![](images/Screenshot-create-project.png)
    4. From the new project page, select Project settings from the left navigation.
    ![](images/Screenshot-project-settings.png)
    5. On the Project Settings page, select Pipelines > Service connections, then select New service connection, and then select Azure Resource Manager from the dropdown.
    ![](images/Screenshot-create-service-connection.png)
    ![](images/Screenshot-create-service-connection2.png)
    ![](images/Screenshot-create-service-connection3png)
    ![](images/Screenshot-create-service-connection4.png)
    6. Select Pipeline and create a new one.
    ![](images/9-newpipeline.png)  
    Create the GitHub Integration
    ![](images/10-github-integration.png)  
    Select your the repository to watch
    ![](images/Screenshot-select-repo.png)  
    Select **Python to Linux Web App on Azure**.
    ![](images/Screenshot-configure.png)  
    Enter the microservice name.
    ![](images/Screenshot-configure2.png)  
    Notice that the YAML is **wrong** at this stage.  Don't worry about that, we'll fix it in a moment.  Go ahead and commit it as-is.
    ![](images/Screenshot-review-yaml.png)
    ![](images/Screenshot-save-yaml.png)

**Sanity check and final test:**
Now go back to Settings | Service Connections.  There should be a connection to GitHub, and the connection to the microservice.  
(The wizard also created a third connection... I didn't make the world, I just live here.)
![](images/Screenshot-service-connections.png)

Now we can make a code change and run the pipeline.  In GitHub, open the repo and edit azure-pipelines.yml.  Change the trigger to `main`.
![](images/Screenshot-edit-yaml.png)
Commit the changes, and the pipeline should start.

The deployment step seems to be somewhat brittle, and you may need to re-run the pipeline for it to succeed.  In this case, the pipeline failed to deploy a couple times, and succeeded on the third attempt.
![](images/Screenshot-pipeline-succeeded.png)

Now go back to the Azure Cloud Shell and check to make sure the microservice actually works.

![](images/Screenshot-final-test.png)

As a fun bonus, the project contains a locust file `locustfile.py` which you can use to max out the F1 tier VM!

![](images/Screenshot-locust.png)

## Enhancements

There a number of ways to improve the project in the future:
- Basic cleanup - remove dead code
- Instead of having the user run through the Azure Pipeline wizard, find a way he can use the existing `azure-pipelines.yml`.
- The main purpose of this assignment (I think) is to demonstrate that we know how to manually create an Azure Pipeline using the web UI.  This UI in turn drives a REST API, which is [documented](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/create?view=azure-devops-rest-4.1).  In other words, the process could be scripted.
- As target environments come and go, corresponding devops pipelines may want to come and go with them.  To me this seems like an unusual scenario; however, there actually is an [Azure DevOps provider for Terraform](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-use-terraform-to-create-azure-devops-projects/ba-p/1555471).  Judging by its version number, it's probably not yet production quality.

## Demo 

And last but not least, here is the [YouTube video](https://youtu.be/Fsn5DOfTtDM).
     
 
