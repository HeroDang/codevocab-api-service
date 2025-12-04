
SE405 - Vocabulary Learning App (Backend System)
===============================================

This project contains:
1. PostgreSQL database (auto init)
2. pgAdmin (UI management)
3. API Service (FastAPI + SQLAlchemy ORM)
4. Docker Compose orchestration

Folder Structure
----------------
<img width="517" height="220" alt="image" src="https://github.com/user-attachments/assets/00b6bc90-a266-4694-bcbd-32093e2a2133" />

-------------------------------------------
HOW TO RUN THE SYSTEM (FOR TEAM MEMBERS)
-------------------------------------------

1. Install required software:
   - Docker Desktop
   - Git

2. Clone the project:
   git clone <repo-url>

3. Start Docker Desktop.

4. Inside project-root folder:
   docker compose up --build -d

5. Services will start at:

   - FastAPI API:
       http://localhost:8000
       Swagger UI: http://localhost:8000/docs

   - PostgreSQL database:
       Host: localhost
       Port: 5432
       User: postgres
       Password: 123456
       DB: appdb

   - pgAdmin:
       http://localhost:8080
       Email: admin@example.com
       Password: 123456

-------------------------------------------
RESET DATABASE (when tables or schema change)
-------------------------------------------

docker compose down -v
docker compose up -d

The SQL files in db/init/ will run automatically:
- 01_create_tables.sql
- 02_seed_data.sql

-------------------------------------------
API SERVICE LOCATION
-------------------------------------------
The FastAPI backend source code is inside:

<img width="263" height="246" alt="image" src="https://github.com/user-attachments/assets/6351c116-fca7-407e-b2bb-bcb18f0fe87b" />


-------------------------------------------
DEVELOPMENT WORKFLOW (FOR TEAM)
-------------------------------------------

Branch strategy:
- main      -> stable version
- dev       -> development branch
- feature/* -> member features

After pulling new code:
1. docker compose down
2. docker compose up --build -d

-------------------------------------------
CONTACT
-------------------------------------------
Team: SE405 - Vocabulary Learning App
