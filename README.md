# Django Project Containerized Quickstart

Building your first [Django](https://docs.djangoproject.com/) web engine project can often be a bit daunting.  It can be even more challenging when it comes to asking for collaberation or attempting deployment to production environments - due to every environment being just a bit different.  

This project is a 'starter seed' that will allow a simple, gentle and quick introduction to building a containerized, scalable, code-versioned, Django web engine with some general best-practices included along the way.  

Please feel free to contribute and comment!

## Lets get started

Assumptions:  

- You are using a Linux-based development environment and have a working knowledge of the commands for using it.  This includes knowing what a reference to 'localhost' is etc. [Microsoft WSL](https://learn.microsoft.com/en-us/windows/wsl/install) is perfectly acceptable for this, but the instalation of that is not covered in this project.  
- [Docker](https://docs.docker.com/get-docker/) is already installed and running in the development eenvironment - and you know how to use the basic commands.
- Basic knowledge of [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and it's purpose as well as it being installed and available in the development environment that you will be using.
- Basic understanding of web services and application development. See https://www.w3.org/TR/ws-arch/ for some details.

If there is enough interest, we will create another document on using WSL as a development platform for this type of project - with all the specifics, tricks, and cool toys that it adds.

### Clone The Codebase

Start by cloning this repository to your local development environment:

    git clone https://github.com/btc-raspberrypiclub/django-start mywebapp
    cd mywebapp

You will now see the base project files in your `mywebapp/` folder.  

### Set Environment Variables

Rename the supplied `.env_example` file to `.env` and edit the values to something more secure.  These values will overide the ones that are in the setup.py and other places.

    mv .env_example .env

The `.env` file is not tracked by Git, since it is specifically excluded via the `.gitignore` file.  This is because the values in this file include 'secrets' that you should never check in with your code.

Feel free to leave the values as they are for now if you are just practicing, if you intend to deploy this project to a server that is available on the internet - you _will_ want to use more secure values.

### Build The Image

Next, build the local image for your container using the supplied code:

    docker compose build

### Generate The Basic Site Filesystem

We have a few options here, depending on what our end goal is. Starting with an empty `./app` directory (default) choose one of the following:

- Create your project by simply bringing up the stack:

    ```docker compose up -d```

    After a few moments, you will see files show up in the `./app` directory.

    Choose this option if you just want a bare-bones Django project with no predefined apps or customizations yet.  This is good for more advanced users - try the DjangoCMS version (below) if this is your first time or you do not yet know what Django is really about.

- Or manually create your project with Django-admin:

    ```docker compose run --rm -it --entrypoint "django-admin startproject webengine ." webengine```
    This allows the definition of other parameters and customizations at the time of creation.  This is basically the same as the option above, but this is how we can add more flags and custom options into the initial generation of the site code.

- _SUGGESTED FOR BEGINNERS_ - manually create your project with the extremely popular [DjangoCMS](https://docs.django-cms.org/en/latest/) - a complete content management system that can be compared to Wordpress, but better ;) :

    ```docker compose run --rm -it --entrypoint "djangocms webengine ." webengine```

    You can safely ignore any warnings about "Requirements not installed" - they are already added from the `app/requirements.in` file to the master `requirements.txt` file for you. Learn more about the [requirements.txt](https://realpython.com/what-is-pip/#using-requirements-files) file.

Now ensure that the project and it's components are properly shutdown:

    docker compose down

After this creation step, the files will be owned by `root` (default), and you will probably want to change this like so:

    sudo chown -R ${UID:-1000}:${GID:-1000} app

This will change the ownership back to yourself for easier access and editing.  NOTE: `$UID` is a Linux variable that contains the USER_ID for the current user (YOU) and the `$GID` is the current primary GROUP_ID of the current user (also YOU) - this is a shell thing, but it is always nice to remember such things.

### Decouple and re-initialize the repo as your own!

We can now delete the `.git` directory from the root of the project and this will completely disconnect the project from the original source control.  From the root of the project folder (i.e. `/mywebapp`):

    rm -rf .git

Remember to leave the `.gitignore` file as-is for now, however.

Initialize `git` again with default settings and then commit all of the important files like so:

    git init
    git add --all
    git commit -m 'Initial import'

The existing `.gitignore` file will help to insure that the proper files are excluded/included in this new repository.  Over time, you may need to modify it to include or exclude new files.  You can always see what is tracked in Git (and pending an add/commit) after an edit by executing `git status`.


### Use a "real" Database

By default, SQLite is selected by Django as the database engine to make rapid protoyping much easier.  However, SQLite is not a particularly great choice in real deployment scenarios due to some fairly serious limitations. So, lets upgrade to a database solution that is a bit more robust. Start by editing the `settings.py` file (found inside the `mywebapp/app/webengine/` directory).py file and looking for where the `DATABASES` are defined.  Make it look like the following:

    DATABASES = {
        'default': {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": "webeginedatabase",
            "USER": "siteuser",
            "PASSWORD": "supersecretpassword",
            "HOST": "db",
            "PORT": "5432",
        }
    }

This will point the Django engine at the Postgres container that is already defined in our stack.

Now you can run the project fully (in background/daemon mode) with:

    docker compose up -d

### Browse The Site For The First Time
You should be able to browse your new site on port `8080` - typically http://127.0.0.1:8080 if you are developing on the linux localhost system.  However, in most developer scenarios you will need to allow other hosts to view the site.  To do that, simply edit the `settings.py` file (found inside the `mywebapp/app/webengine/` directory) so that the [ALLOWED_HOSTS](https://docs.djangoproject.com/en/5.0/ref/settings/#allowed-hosts) entry looks something like:

    ALLOWED_HOSTS = ['*']

Dont omit the apostrophes, they are important!  This is a common mistake and will cause the site to fail and crash.  You can also use the external IP of the server it is running on - but that is a more complex task for later on.

This is not something that you will want to leave this way once you begin progressing toward a production intent, but it makes things considerably easier/simpler for the moment as you begin to develop your service the first time.

With the stack running in development mode as it currently is, you can edit the `settings.py` file and it will immediately take effect without restarting the container or service.  Try refreshing the browser and you should see the initial site pop-up now.

### Create a Super User

Now, you will need to create a superuser to log in with. 

    docker compose run --rm -it --entrypoint "./manage.py createsuperuser" webengine

It will prompt you for information to create the user account.  Fill in apropriate values for your usage, and then use them to log into the site within your browser.

### Start The Commit Habbit

Now that we have made some important changes to our code and tested them successfully, it is a good time to execute a quick `git status` in your project folder and see what files have changes that need to be committed to our repo.

Use `git` to add each changed file as well as a note that explains the changes, then commit each of them.

### Import to a Hosted Repo (optional - but suggested)

Up till now, all of your local changes are only tracked in the local `.git` folder.  You may want something a little more Next, you may want to track this with a hosted code repository such as GiHub, GitLab, BitBucket, etc ...or even an on-premise or internal-corporate hosted service.  Follow that system's documentation on how to proceed importing it, it should be pretty simple.  Below is an example of using GitHub.

To import a project into GitHub, follow these steps:

1. Create a new repository on GitHub. You can do this by clicking on the "New" button on the main page of your GitHub account.

2. Give your repository a name and choose whether it should be public or private.

3. Once the repository is created, copy the URL of the repository. It should look something like `https://github.com/your-username/your-repo.git`.

4. In your local project directory, initialize Git if you haven't already done so by running the command `git init`.

5. Add all the files in your project to the Git repository by running the command `git add --all`.

6. Commit the changes by running the command `git commit -m 'Initial import'`.

7. Set the remote repository URL by running the command `git remote add origin <repository-url>`, replacing `<repository-url>` with the URL you copied in step 3.

8. Push the code to the remote repository by running the command `git push -u origin master`.

9. Enter your GitHub username and password when prompted.

10. Refresh the GitHub repository page, and you should see your project files and commit history.

That's it! Your project is now imported into GitHub. You can continue to make changes to your project locally and push them to the remote repository using Git commands.

### Enable the Django Debug Toolbar

See https://django-debug-toolbar.readthedocs.io/ for more details.

In settings.py modify `INSTALLED_APPS` by inserting the following line:

    'debug_toolbar',

...modify the `MIDDLEWARE` by inserting this line:

    'debug_toolbar.middleware.DebugToolbarMiddleware',

...and add this to the bottom of the file, on it's own:

    DEBUG_TOOLBAR_CONFIG = {
        'SHOW_TOOLBAR_CALLBACK': lambda request: False if request.META.get('HTTP_X_REQUESTED_WITH') == 'XMLHttpRequest' else True,
    }

Add the following to the bottom of your `urls.py` file:

    from debug_toolbar.toolbar import debug_toolbar_urls
    if settings.DEBUG:
        urlpatterns += debug_toolbar_urls()


## Next Steps and Bits

(TBD) 

Suggested options (to be detailed soon) including general CI/CD and collaberation:

- detail both [gunicorn](https://gunicorn.org/) (implement a prefork worker model http service)
- adding some good applications for any/most projects, such as:
  - Django REST
  - Django Extensions
  - etc (see https://djangopackages.org/ for more examples)
- advanced debugging techniques - set up automatic container image creation using 
  - GitHub Container Registry
  - Docker Hub
  - etc.
- setup your repo for Pull Requests and external collaberation with other developers in a safe/sane way
- developing your own first application within your project
- how to - using Docker secrets and configs