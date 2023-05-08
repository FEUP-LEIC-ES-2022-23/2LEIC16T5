
## Project management

You can find below information and references related with the project management in our team: 

* Backlog management: Product backlog and Iteration backlog in a [Github Projects board](https://github.com/orgs/FEUP-LEIC-ES-2022-23/projects/30);
* Release management: [v0](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC16T5/releases/tag/v0), [v1](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC16T5/releases/tag/v1), [v2](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC16T5/releases/tag/v2), v3, v4;
* Iteration planning and retrospectives: 

  ### Iteration 0
  
  <img width="1440" alt="Iteration0_Backlog" src="https://user-images.githubusercontent.com/92641892/228287213-0a00ead1-f501-4f2f-9215-d468a9785dba.png">
  
  ### Iteration 1

  We were planning on completing the 5 features below, but unfortunately the "Categories" feature is still in progress, since we came across some issues during the creation of our SQLite Database. However, we managed to balance that, by implementing another feature which was not planned and whose effort and priority values are the same: the "Reset Data" feature.
  
  #### Begin
 
  <img width="1440" alt="Iteration1_Begin" src="https://user-images.githubusercontent.com/92641892/229573624-a17bf147-d121-4aa4-b863-d10990a9d325.png">
  
  #### End
  
  <img width="1440" alt="Iteration1_End" src="https://user-images.githubusercontent.com/92641892/229573629-8c62a750-9024-4af1-bec6-ab66e55703ce.png">
  
  #### Retrospectives
  
  * What went well
    * We were able to connect our app with Firebase, which enabled us to fully implement the Login feature
    * The Transactions are now fully functional
    * Although it wasn't planned, we ended up implementing the Reset Data feature, which turned out to be trully useful for testing

  * What went wrong
    * It took us a while to discover how to store the same variable, but with different types, in SQLite and Flutter
    * The Categories feature ended up not being fully implemtned, due to the issue discribed in the last topic

  * What is still a problem
    * We haven't been able to connect our Firebase database with our SQLite one, but we're working on it

### Iteration 2

  Once again, we were unable to fullfill all our expectations, although we believe we accomplished some outstanding remarks: the connection with both Firebase and GoogleMaps API, and the implementation of the required tests (Unit and Acceptance). Plus, we managed to finish the "Categories" feature, which was left behind on the last iteration.
  
  #### Begin
 
  <img width="940" alt="Iteration2_Begin" src="https://user-images.githubusercontent.com/92641892/232618821-0594b135-02e1-45dc-87a2-df406ef99a69.png">
  
  #### End
  
  <img width="948" alt="Iteration2_End" src="https://user-images.githubusercontent.com/92641892/232920659-21f64140-2bbc-4c8c-a3e0-f062f085cd05.png">
  
  #### Retrospectives
  
  * What went well
    * We successfully connected our app with Firebase
    * The acceptance tests (although started as a struggle) are now mastered
    * The connection with the GoogleMaps API was fairly simple

  * What went wrong
    * It was a struggle to develop the Unit Tests, due to Firebase issues
    * Because of the last topic, we were unnable to fullfill the "Dark Mode" feature

  * What is still a problem
    * Accomplishing to implement all the features we initially planned
    
### Iteration 3

  This time, we managed to set realistic expectations, which allowed us to get all the user stories for this iteration to the DoneDoneDone✅. Our users are now able to check their monthly statistics, compare their yearly spendings with the National average, set budget limits for their categories, and see all the data associated with each transaction they have created. 
  
  #### Begin
 
  <img width="1440" alt="Iteration3_Begin" src="https://user-images.githubusercontent.com/92641892/235792767-8d54bf9d-a4ac-4405-b2bd-63b341aae1a1.png">
  
  #### End
  
  <img width="939" alt="Iteration3_End" src="https://user-images.githubusercontent.com/92641892/235792769-33cfbb6f-a9df-47ce-8819-1b66519a4e35.png">
  
  #### Retrospectives
  
  * What went well
    * We were finally able to fulfil all our expectations in terms os user stories 

  * What went wrong
    * It turned out impossible to get the data we needed directly from [PORDATA](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela). Instead, we chose to export it as a cvs file, and then read it from there in the app
    * Since we focused on accomplishing all the user stories for this iteration, we ended up misprizing the Unit Tests (which we hope to balance on the next iteration)

  * What is still a problem
    * Time managing. We tend to leave everything to the last minute


 
