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
import users from "@/apollo/gqls/queries/users";
import CreateUser from "@/apollo/gqls/mutations/CreateUser";

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
        await this.$apollo.mutate({
          mutation: CreateUser,
          variables: {
            id: newUser.id,
            name: newUser.name,
          },
          refetchQueries: [
            {
              query: users,
            },
          ],
        });
        this.newUser = { name: "" };
      } catch (e) {
        window.console.log(e);
      }
    },
  },
  apollo: {
    users: {
      query: users,
    },
  },
};
</script>
