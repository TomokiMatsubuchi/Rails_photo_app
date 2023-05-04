<template>
  <v-container>
    <h2>写真一覧</h2>
    <div v-for="photo in photos" :key="photo.id">
      <strong>title: {{ photo.title }}</strong>
      <p>description: {{ photo.description }}</p>
    </div>
  </v-container>
</template>

<script>
import generateQuery from "@/plugins/generateQuery";
import photosQuery from "@/pages/gqls/queries/Photos.gql";

const getPhotosQuery = generateQuery(photosQuery);

export default {
  methods: {
    async getPhotos() {
      try {
        const response = await this.$axios.post("/graphql", {
          query: getPhotosQuery,
        });
        this.photos = response.data.data.photos;
      } catch (err) {
        console.log(err);
      }
    },
  },
  created() {
    this.getPhotos();
  },
};
</script>
