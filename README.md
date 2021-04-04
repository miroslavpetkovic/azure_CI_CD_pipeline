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
    
   #### Continuous Delivery - Azure Pipelines & Azure App Service

   1. Set up a python virtual environment and activate it.  In this this example it's named 'cicd'.  
   ![venv](images/Screenshot-venv.png)

   2 Build the project.
   ```bash
   cd udacity-cicd-pipeline
   make all
   ```
  ![venv](images/Screenshot-make-all.png)

   3. Run the microservice 'locally' (i.e. in the Cloud Shell).
   ![Service Running Locally](images/Screenshot-local-service.png)
   Open a second console and run `curl localhost:5000`.  The microservice should respond with some HTML.
   ![Test service](images/Screenshot-curl.png)

    4. Deploy, run and test the microservice in Azure App Services.  
   This will make it available over the internet.  Equally important, it will implicitly create a VM.  In a moment, this will become the target for the CD pipeline to deploy its content _to_.
    1. Back in the main Cloud Shell, `export FLASK_APP=app.py`, so flask knows what to run in the Azure App.
    2. Pick a name for your microservice.  This name will appear in the publicly available URL.
    3. Replace `<yourappname>` in `make_predict_azure_app.sh`
    4. Create the resource group and VM, upload the contents of the current directory and launch flask with `az webapp up`.  You will use the name for this command as well.  (here it's `udacity-flask-ml-service`)
    ![App Service](images/Screenshot-app-service1.png)
    ![App Service](images/Screenshot-app-service2.png)

   Check(list):**  `az webapp up` did quite a few things behind the scenes, so there are a few things to check for
    - The output contains the message `You can launch the app at ...`
    - The output prints out JSON, and it contains the string `"sku": "FREE"`
    - Hitting the website with `curl` produces the same HTML output it did in the previous step, when the service was run 'locally'.
    - Running `./make_predict_azure_app.sh` responds with JSON.

   5. In the second command window, tail the logs of the running Azure App with `azure webapp log tail`, e.g.

   ```bash
   az webapp log tail --resource-group PaulWilliams_Redmond_rg_Linux_centralus -n udacity-flask-ml-service
   ```
   Check:** Back in the main Cloud Shell, run `./make_predict_azure_app.sh`.  The request should be logged in the second Cloud Shell.
   ![](images/Screenshot-log-tail1.png)

## Demo 

And last but not least, here is the [YouTube video](https://youtu.be/Fsn5DOfTtDM).
     
 
