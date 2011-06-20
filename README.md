Mardoc
======

Mardoc is an easy to use documentation server. You write documentation in markdown and use rack to serve it up.


    Usage:
      mardoc init PROJECT_PATH

    Description:
      The `mardoc init' command generates a mardoc project template.

      Once you have a project template, you can start dropping markup documenation
      files in the `docs' directory. After you have some documenation, just run rackup
      in the mardoc project directory to start the server and view the documentation.

      Edit the layout and the files in the assets folder to style or add images to the documentation.

    Example:
      mardoc init ~/Dev/documentation
      cd ~/Dev/documentation

      # add some documentation to ~/Dev/documentation/docs
      echo "# Hello World" >> ~/Dev/documentation/docs/hello.md 

      # fire up a server
      rackup

      # view the docs
      curl http://0.0.0.0:9292/hello
      
      
Installation
------------

    $ gem install mardoc