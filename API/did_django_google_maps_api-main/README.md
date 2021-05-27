

cd to development directory

mkvirtualenv did_django_google_maps_api

mkdir did_django_google_maps_api

clone repository to new directory

pip install -r requirements.txt

Update settings.py with your email API information

GOOGLE_API_KEY = "XXX"


python manage.py makemigrations

python manage.py migrate

python manage.py runserver

https://localhost:8000 
