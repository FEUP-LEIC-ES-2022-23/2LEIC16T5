
## Requirements

In this section, you will find all kinds of requirements for our module: functional and non-functional.

### Domain Model

Here we present you our Domain Model, as well as a short description of each class:

**User** - The users need a way to identify themselves in our system, therefore they have a username and a password. They can also set a monthly budget for their expenses, which may be rewritten every month.

**UserSettings** - Each user can configure its own settings, where they can select their preferred currency, switch between light and dark mode, and turn notifications on and off.

**SavingGoal** - Each user can set multiple saving goals, in order to check their progress towards them. For this to happen, all of them feature a name, a current and a target value, and may even have a target date to achieve this goal.

**Category** - Users can set their own categories for their transactions (for example, “Food”, “University”, etc), which have a colour for easy distinction and may have a monthly set budget associated to them.

**Transaction** - In our app, we consider that there are two types of transactions: **Income** and **Expense**. Both have a total (earned or spent, respectively) and a category associated to them. They may also have a name, a date, some notes and may be recurrent, hence why they may have a “repeat” attribute. Although they share a lot in common, the latter can also have a location.

![DomainModel](https://user-images.githubusercontent.com/92641892/225037047-7e1d8874-73b6-47bf-9b12-1401c17d6800.jpeg)
