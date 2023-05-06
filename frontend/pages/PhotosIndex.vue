<template>
  <v-container>
    <h2>写真一覧</h2>
    <v-btn color="primary" @click="showCreateModal = true">新規作成</v-btn>

    <!-- モーダルダイアログ -->
    <v-dialog v-model="showCreateModal">
      <v-card>
        <v-card-title>新規写真作成</v-card-title>
        <v-card-text>
          <!-- Photo作成用フォーム -->
          <v-form @submit.prevent="createPhoto">
            <v-text-field
              label="タイトル"
              v-model="newPhoto.title"
              required
            ></v-text-field>
            <v-text-field
              label="説明"
              v-model="newPhoto.description"
            ></v-text-field>
            <v-btn color="primary" type="submit">作成</v-btn>
          </v-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    <v-row>
      <v-col v-for="photo in photos" :key="photo.id" cols="12" md="6" lg="4">
        <v-card>
          <!--<v-img :src="photo.imageUrl" alt="Photo"></v-img>-->
          <v-card-title>{{ photo.title }}</v-card-title>
          <v-card-text>{{ photo.description }}</v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import generateQuery from "@/plugins/generateQuery";
import photosQuery from "@/pages/gqls/queries/Photos.gql";
import createPhotoMutation from "@/pages/gqls/mutations/CreatePhoto.gql";

const getPhotosQuery = generateQuery(photosQuery);
const addPhotoMutation = generateQuery(createPhotoMutation);

export default {
  data() {
    return {
      photos: [],
      showCreateModal: false, // モーダルを表示するかどうかのフラグ
      newPhoto: {
        title: "",
        description: "",
      }, // 新規写真作成用データ
    };
  },
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
    async createPhoto() {
      try {
        await this.$axios.post("/graphql", {
          query: addPhotoMutation,
          variables: {
            title: this.newPhoto.title,
            description: this.newPhoto.description,
          },
        });
        // 新しいPhotoを配列の先頭に追加
        this.photos.push(this.newPhoto);
        // モーダルを閉じる
        this.showCreateModal = false;
        // フォーム情報を初期化
        this.newPhoto = {
          title: "",
          description: "",
        };
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
