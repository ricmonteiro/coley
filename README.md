INSTRUCTIONS TO INSTALL AND RUN COLEY

    • Download Docker desktop for you Operating System (https://www.Docker.com/products/Docker-desktop/);
      
    • Download the coley repo to your local machine (https://github.com/ricmonteiro/coley);
      
    • Open a terminal window and go to the repo folder;
      
    • Run the commands:
        ◦ docker compose build;
        ◦ docker compose up -d;
          
    • Go to the database container in Docker Desktop. On the terminal, go to the home/coleydata folder. Run the commands:
        ◦ psql -U postgres;
        ◦ \i init.sql;
          
    • Go to the the funcionalities folder;
      
    • Run all the scripts for database functions and procedures creation:
        ◦ \i script_name.sql
          
    • Go to http://localhost:3000;
      
    • coley is now running on your local machine.
