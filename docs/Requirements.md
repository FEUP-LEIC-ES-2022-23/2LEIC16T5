
## Requirements

In this section, you will find all kinds of requirements for our module: functional and non-functional.

### Domain Model

Here we present you our Domain Model, as well as a short description of each class:

**User** - The users need a way to identify themselves in our system, therefore they need to provide an email and create a password.

**UserSettings** - Each user can configure its own settings, where they can switch between light and dark mode, and turn notifications on and off. In order to select their preferred **Currency**, there is an enum where its symbol can be chosen.

**SavingGoal** - Each user can set multiple saving goals, in order to check their progress towards them. For this to happen, all of them feature a name, a current and a target value, and may even have a target date to achieve this goal.

**Category** - Users can set their own categories for their transactions (for example, “Food”, “University”, etc), which have a color (hence the RGB attributes) for easy distinction.

**Budget** - Users are able to set monthly budgets on each of their categories. 

**Transaction** - In our app, we consider that there are two types of transactions: **Income** and **Expense**. Both have a total (earned or spent, respectively) and a category associated to them. They may also have a name, a date and some notes. Although they share a lot in common, the latter can also have a location.

**Repeat** - For practical purposes, we consider that transactions may be repeated every X days. This is a user defined time interval, which will then trigger the creation of new transactions, until further notice.

![DomainModel](https://user-images.githubusercontent.com/92641892/235801297-09c25aac-b59d-4b50-a5ec-5ed80b8ef50c.jpeg)
