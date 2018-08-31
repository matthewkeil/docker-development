const Query = {
  getAllIngredient: async (_, __, ctx) => ctx.Ingredient.find(),
  getAllRecipe: async (_, __, ctx) => ctx.Recipe.find(),
  getAllItem: async (_, __, ctx) => ctx.MenuItem.find(),
  getAllMenu: async (_, __, ctx) => ctx.Menu.find()
};

const Mutation = {
  newIngredient: async (_, { name }, ctx) => {
    try {
      const ingredient = new ctx.Ingredient({
        name,
        created: { by: ctx.USER }
      });
      await ingredient.save();
      return ingredient;
    } catch (err) {
      return err;
    }
  },
  newRecipe: async (_, { name }, ctx) => {
    // return new ctx.Recipe(args);
  },
  newMenuItem: async (_, { name }, ctx) => {
    // return new ctx.MenuItem(args);
  },
  newMenu: async (_, { name }, ctx) => {
    // return new ctx.Menu(args);
  }
};

export const resolvers = {
  Query,
  Mutation
};
