
## Requirements

In this section, you will find all kinds of requirements for our module: functional and non-functional.

### Domain Model

Here we present you our Domain Model, as well as a short description of each class:

**User** - The users need a way to identify themselves in our system, therefore they need to provide an email and create a password.

**Transaction** - In our app, we consider that there are two types of transactions: **Income** and **Expense**. Both have a total (earned or spent, respectively), a date and a category associated to them. They may also have a name and some notes. Although they share a lot in common, the latter can also have a location.

**Category** - Users can set their own categories for their transactions (for example, “Food”, “University”, etc), which have a color for easy distinction.

**Budget** - Users are able to set monthly budgets on each of their categories, so they can see how close (or not) they are to the limit they set themselves.

**SavingGoal** - Each user can set multiple saving goals, in order to check their progress towards them. For this to happen, all of them feature a name, a current and a target value, and may even have a target date to achieve this goal. 

__\<<enum\>> Currency__ - Each user can choose their preferred currency symbol.

![DomainModel](https://github.com/SofiaViP/hero/assets/92641892/31646d5a-a140-405b-97e4-9e56b7f8d3b3)
