
## Architecture and Design
The architecture of a software system encompasses the set of key decisions about its overall organization. 

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them. 

In this section we briefly describe the overall components of our project and their interrelations.

### Logical architecture

Our Logical Architecture diagram shows the different layers and packages that compose our app.

The Fortuneko System contains the core functionality of our app. It is further divided into three other packages: Fortuneko UI, Fortuneko Business Logic and Fortuneko database. The first one handles the UI of our app. The second one, contains the logic that drives our app’s behaviour. The third one, contains the data storage and retrieval logic of our app.
The *External Services* holds the dependencies of our app, namely the [*Google Maps API*](https://developers.google.com/maps), [*Firestore*](https://firebase.google.com/docs/firestore), [*Firebase Authentication*](https://firebase.google.com/docs/auth)and the [*PORDATA database*](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela). 

![LogicalArchitecture](https://github.com/SofiaViP/hero/assets/92641892/0c8c2545-4e52-48fb-83de-6abf163eff9c)

### Physical architecture

Our Physical Architecture diagram shows our mobile app, connected to all the dependencies we have identified. Firebase is used for authentication and Firestore for storage. Both are used for synchronisation of user data across multiple devices. Google Maps API is used for generating a geographical chart of expenses. PORDATA database provides the “National Comparison” feature. Therefore, this diagram illustrates the communication and data flow between Fortuneko app and these external services.

![PhysicalArchitecture](https://github.com/SofiaViP/hero/assets/92641892/613e402e-e356-4365-b05e-ee6f07d1ee64)

### Vertical prototype

For now, we have superficially implemented some of the [main features](./ProductVision.md/#Main-Features), such as the login, the transactions menu, and the settings. As a way of merging these all together, we also found it useful to create a prototype of the main menu, although some of its buttons are still functionless. We have also successfully configured [Firebase](https://firebase.google.com), despite the fact that we are still in the process of integrating it into our app.

