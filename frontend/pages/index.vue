<template>
  <div>
    <div v-for="(user, index) in users" :key="user.id">
      <p>{{ index + 1 }}. {{ user.name }}</p>
    </div>
  </div>
</template>
<script>
import users from '~/apollo/gqls/queries/users';

export default {
  data() {
    return {
      users: {}
    }
  },
  apollo: {
    users: {
      query: users
    }
  }
}
</script>