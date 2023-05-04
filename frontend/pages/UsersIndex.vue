<template>
  <v-container>
    <v-row>
      <v-col cols="6" offset="3">
        <v-card>
          <v-card-title>Register User</v-card-title>
          <v-card-text>
            <v-form>
              <v-container>
                <v-row>
                  <v-col cols="6">
                    <v-text-field
                      v-model="newUser.name"
                      label="Name"
                      required
                    />
                  </v-col>
                </v-row>
                <v-row>
                  <v-col>
                    <div @click="createUser(newUser)">
                      <v-btn> CreateUser </v-btn>
                    </div>
                  </v-col>
                </v-row>
              </v-container>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row v-for="user in users" :key="user.id">
      <v-col cols="6" offset="3">
        <v-card>
          <v-card-text>{{ user.name }}</v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import UsersQuery from "@/pages/gqls/queries/Users.gql";
import CreateUser from "@/pages/gqls/mutations/CreateUser.gql";
import generateQuery from "@/plugins/generateQuery";

const getUsersQuery = generateQuery(UsersQuery);
const newUserCreateMutation = generateQuery(CreateUser);

export default {
  data() {
    return {
      users: {},
      newUser: {
        name: "",
      },
    };
  },
  methods: {
    async createUser(newUser) {
      try {
        await this.$axios.post("/graphql", {
          query: newUserCreateMutation,
          variables: {
            name: newUser.name,
          },
        });
        this.getUsers();
        this.newUser.name = "";
      } catch (err) {
        console.log(err.response);
      }
    },
    async getUsers() {
      try {
        const response = await this.$axios.post("/graphql", {
          query: getUsersQuery,
        });
        this.users = response.data.data.users;
      } catch (err) {
        console.log(err);
      }
    },
  },
  created() {
    this.getUsers();
  },
};
</script>
