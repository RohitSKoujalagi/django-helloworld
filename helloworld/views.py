from django.http import HttpResponse

def index(request):
 return HttpResponse("Namaste, Duniya!\n") 
