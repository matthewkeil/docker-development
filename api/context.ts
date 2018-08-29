import * as https from "https";
import * as mongoose from "mongoose";
import * as jwt from "jsonwebtoken";

const Schema = mongoose.Schema;

interface USER {
  id: any;
  email: string;
  password: string;
}

const userSchema = new Schema({
  email: String,
  password: String
});
const User = mongoose.model("User", userSchema);

// type Ingredient {
//     id: ID!
//     name: String!
//     createdAt: Int!
//     createdBy: User!
// }
const ingredientSchema = new Schema({
  name: { type: String, required: true },
  shortID: String!,
  created: {
    on: { type: Number, default: Date.now() },
    by: { type: userSchema, required: true }
  }
});
const Ingredient = mongoose.model("Ingredient", ingredientSchema);

// type Recipe {
//   id: ID!
//   name: String!
//   createdAt: Int!
//   createdBy: User!
//   ingredients: [Ingredient!]
//   inItem: [MenuItem!]
// }
const recipeSchema = new Schema({
  name: String!,
  shortID: String,
  created: {
    on: { type: Number, default: Date.now() },
    by: { type: userSchema, required: true }
  },
  ingredients: [ingredientSchema!]!
});
const Recipe = mongoose.model("Recipe", recipeSchema);

// type MenuItem {
//   id: ID!
//   name: String!
//   createdAt: Int!
//   createdBy: User!
//   recipes: [Recipe!]
//   inSection: [MenuSection!]
// }
const menuItemSchema = new Schema({
  name: String!,
  shortID: String,
  created: {
    on: { type: Number, default: Date.now() },
    by: { type: userSchema, required: true }
  },
  recipes: [recipeSchema!]!
});
const MenuItem = mongoose.model("MenuItem", menuItemSchema);

// type MenuSection {
//   id: ID!
//   name: String!
//   createdAt: Int!
//   createdBy: User!
//   items: [MenuItem!]
//   inMenu: [Menu!]
// }
const menuSectionSchema = new Schema({
  name: String!,
  items: [menuItemSchema!]!
});

// type Menu {
//   id: ID!
//   name: String!
//   createdAt: Int!
//   createdBy: User!
//   sections: [MenuSection!]
// }
const menuSchema = new Schema({
  name: String!,
  shortID: String,
  created: {
    on: { type: Number, default: Date.now() },
    by: { type: userSchema, required: true }
  },
  sections: [menuSectionSchema!]!
});
const Menu = mongoose.model("Menu", menuSchema);

const models = {
  User,
  Ingredient,
  Recipe,
  MenuItem,
  Menu
};

type Context = typeof models & { REQ: https.IncomingRequest; USER: USER };

export default async (req: https.IncomingRequest) => {
  let USER;

  if (req.headers.authorization) {
    const token = (Array.isArray(req.headers.authorization)
      ? req.headers.authorization[0]
      : req.headers.authorization
    ).split(" ")[1];

    const { id } = await jwt.verify(token, process.env.JWT_SECRET);
    USER = await User.find({ id });
  }

  return { ...models, USER, REQ: req } as Context;
};
