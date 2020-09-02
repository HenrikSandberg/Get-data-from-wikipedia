# Vipps - Planning for failure
I have little experience whit this types of problems (mostly a frontend developer), however I came across some problems like this when I was working for Repairable. I hope my answers are somewhat satisfactory. 

## Unhappy Customer 1
** User clicks submit -\> waits 30 seconds -\> nothing happens -\> user is charged and order is shipped.**
This could be a network error. This can occur on the users side or on the service side. Either way, this might result in the frontend not receiving a confirmation form the backend/payment system that the order is completed.  It seems like everything else worked correctly. 

There might also be a situation where the frontend is expecting an answer from the backend in the form of a variable with a specific name and that the backend now is updated and no longer sendes this specific variable. 

My proposed solution is to check if the frontend is expecting the correct information from the backend. Maby check change log for the backend in order to know if there is some differences in the system. If there is a difference update the frontend so it now is inline with the current backend information. 

## Unhappy Customer 2
** User clicks submit -\> waits 45 seconds -\> user is charged twice -\> UI updates to say order is shipped.**
This also might come form a networking error. If the network is slow and after a given time the frontend is trying to resend the request. If the frontend then receives a response it does not care if it is from the first or second request. In this case it seems that the backend is not checking if the exact request was newly sendt. And from what I can tell the user will receive two exact orders, which would not be optimal. 

My proposed solution here is to check the backend code. And make a check if an order with a given order ID already exists in the database. 

## Unhappy Customer 3
** User clicks submit -\> nothing happens -\> user clicks submit again -\> UI updates to say order is shipped. User was charged twice, order shipped once.**
Sounds like it is related to the problem above, however this time the code check to see if the order already exists. So the problem in this scenario is that the backend only checks if the order exist and not if the payment api is called. Again this might occur because of a slow network connection but it is hard to tell based on the information given. The problem is still withstanding tho. If the backend has a check to see if the order exists it should also check if a payment has been created on that order as well. If the creation of the order and the payment is asynchronous from one and other there might be a problem in that one is finished before the other. 

My proposed solution would be to check if a payment also has been made with the order. Then the order check should not return anything before it gets a respons from the payment api. 