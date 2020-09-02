# Get data from wikipedia
 This repo contains a simple code that gets data from wikipedia and counts for occurrences of the topic in the article.

## What I would have changed 
The assignment was to complete this it in under two hours. Because of the time constraint the code is not as optimal as I would have liked it to be. The code is only in script form. In a real world scenario this would be split up into several files and had a greater reusability factor. 

The code used for doing URL Sessions, counter function and urlString variable should probably be more generic class and put into a model folder. This class at init should require a topic at initialisation. 

I love using the extension of Strings and other generic types in Swift, however this also should be in a separat file. Preferably a library fil or extension file so it is Clare what it does. 

Since the «Frontend» in this scenario was so simple I decided that it would not be time well spent making a frontend, so I only got call on the information and update the user when the data is returned. In a more realistic scenario this might be called in a view file. If the view file was a SwiftUI file the code from the model would update a State or observable object variable so that the frontend only had updated when the code returned. 