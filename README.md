# Overview

This project details steps for building a Github repository and creating an application scaffolding for a Machine Learning Flask Web App, to perform both continuous integration and continuous delivery. First by using Github Actions to perform an initial test and then integrating the application with Azure Pipelines to enable continuous delivery to Azure App Service. . 

## Project Plan
The first step is to create a project plan detailing what the tasks are, goals, deadlines, level of difficulty for each task, the person who is responsible for each task etc. This is essential for tracking tasks and making sure that each outlined task is completed in a timely manner in order to ensure completion of all tasks by the target completion date. 

* A link to a Trello board for this project
https://trello.com/b/Kb08gLQl/cloud-devops-using-microsoft-azure-ci-cd-pipeline

* A link to a spreadsheet that includes the original and final project plan>
https://github.com/miroslavpetkovic/azure_CI_CD_pipeline/blob/main/project-management-Miroslav%20P.xlsx

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

  Content of pythonapp.yml file:
   ![pythonapp.yml](./screenshots/pythonapp.yml.PNG)
    
  Successful Continuous Integration:
   ![pythonapp2.yml](./screenshots/pythonapp2.yml.PNG)
   
  Successful Continuous Integration:
   ![pythonapp_build](./screenshots/pythonapp_build.PNG)
    

   
   [![Python application test with Github Actions](https://github.com/miroslavpetkovic/azure_CI_CD_pipeline/actions/workflows/pythonapp.yml/badge.svg)](https://github.com/miroslavpetkovic/azure_CI_CD_pipeline/actions/workflows/pythonapp.yml)
   
   
    
   #### Continuous Delivery - Azure Pipelines & Azure App Service

   1. Set up a python virtual environment and activate it.  In this this example it's named 'cicd-pipeline-web'.  
   ![venv](./screenshots/create_virtual_enviroment2.PNG)

   2 Build the project.
   ```bash
   cd flask-sklearn
   make all
   ```
  ![venv](./screenshots/make_all_flesk.PNG)

   3. Run the microservice 'locally' (i.e. in the Cloud Shell).
   ![Service Running Locally](./screenshots/run_microsevice.PNG)
   
    4. Deploy, run and test the microservice in Azure App Services.  
   This will make it available over the internet.  Equally important, it will implicitly create a VM.  In a moment, this will become the target for the CD pipeline to deploy its content _to_.
    1. Back in the main Cloud Shell, `export FLASK_APP=app.py`, so flask knows what to run in the Azure App.
    2. Pick a name for your microservice.  This name will appear in the publicly available URL.
    3. Replace `<yourappname>` in `make_predict_azure_app.sh`
    4. Create the resource group and VM, upload the contents of the current directory and launch flask with `az webapp up`.  You will use the name for this command as well.  (here it's `udacity-flask-ml-service`)
   
   Deploy, run and test the microservice:
   ![App Service](./screenshots/create_flesk_page_1.PNG)
    
   Access to the created web page:
   ![App Service](./screenshots/web_page.PNG)
   
   Overwiew of App Service at Microsft Azure Portal:
   ![App Service](./screenshots/app_service_overview.png)

   Check(list):**  `az webapp up` did quite a few things behind the scenes, so there are a few things to check for
    - The output contains the message `You can launch the app at ...`
    - The output prints out JSON, and it contains the string `"sku": "FREE"`
    - Hitting the website with `curl` produces the same HTML output it did in the previous step, when the service was run 'locally'.
    - Running `./make_predict_azure_app.sh` responds with JSON.

   5. In the second command window, tail the logs of the running Azure App with `azure webapp log tail`, e.g.

   ```bash
   az webapp log tail --resource-group miroslavpetkovic_rg_Linux_westeurope -n udacity-flask-ml-service-miroslavpetkovic
   ```
   Check:** Back in the main Cloud Shell, run `./make_predict_azure_app.sh`.  The request should be logged in the second Cloud Shell.
   ![link](./screenshots/web_logs.PNG)
   
   ##### Configure Azure pipelines

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
  
   Creating of New pipeline was described above.
     
Now the pipeline is ready. Each time you update your repository, the pipeline will automatically pull the new version, it will try to build the application and if the build is successfull it will deploy it.

If you click on a pipeline you will see the commit history and an indicator if it was built and deployed sucessfully. 
  ![](./screenshots/pipeline1.PNG)

Then you can click on a commit and the build and deploy summary of this commit will be displayed: 
  ![](./screenshots/pipeline2.PNG)

You can also click on the build stage or deploy app to get detaile dstatus. It is useful for debugging in order to pinpoint a problem. 
  ![](./screenshots/pipeline3.PNG)
   
   
   ![](./screenshots/pipeline5.PNG) 
     
   Created azure-pipelines.yml file:
   
   ![](./screenshots/pipeline4.PNG)

   
   #### Load test an application using Locust (swarm the target website from localhost)


   - Running `pip install locust` to install `locust`
   - Open browser and go to [http://localhost:8089/](http://localhost:8089/)
     ![](./screenshots/locust1.PNG)
     
     ![](./screenshots/locust_2.PNG)
     
     ![](./screenshots/locust_3.PNG)
    


## Architecture Diagram

![project diagram](./screenshots/project_diagram.png)

## Enhancements

This is a basic Azure DevOps project that demonstrates a CI/CD pipeline for testing and deploying a Machine Learning application.

Additional features should be taken into account in a commercial application,such as:

* Separate development and production environment
* Restricted permissions for the developers and the DevOps engineers.
* More tests
* Fault tolerant design
* Use a faster VM for the web app


## Demo 

 [YouTube video](https://youtu.be/gyZZhMOUzdo).
 
 Content of demo:
 * 00:00 Overwiew and goals of project
 * 00:56 Create the Python Virtual Environment
 * 01:01 Clone of project in github
 * 01:23 Local Test - make all
 * 01:38 Show passing of GitHub Actions by using of pythonapp.yml
 * 02:54 Build the project - Azure App Services - preparation steps
 * 03:36 Run the microservice 'locally' 
 * 04:09 Deploy, run and test the microservice in Azure App Services
 * 04:29 Overwiew of App Service at Microsft Azure Portal
     
 
