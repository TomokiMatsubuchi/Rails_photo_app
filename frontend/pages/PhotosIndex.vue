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
        <v-card @click="showPhotoDetailModal(photo)">
          <!--<v-img :src="photo.imageUrl" alt="Photo"></v-img>-->
          <v-card-title>{{ photo.title }}</v-card-title>
          <v-card-text>{{ photo.description }}</v-card-text>
          <v-btn color="error" @click="deletePhoto(photo)" class="ml-auto">
            <v-icon>mdi-delete</v-icon>
            <span>Delete</span>
          </v-btn>
        </v-card>
      </v-col>
    </v-row>

    <!-- 写真詳細情報モーダル -->
    <v-dialog v-model="showPhotoDetail" max-width="400">
      <v-card>
        <v-card-title>{{ selectedPhoto.title }}</v-card-title>
        <v-card-text>{{ selectedPhoto.description }}</v-card-text>
        <v-btn @click="prepareEdit" v-if="!isEditing"
          ><v-icon>mdi-pencil</v-icon></v-btn
        >
        <v-btn @click="deletePhoto(selectedPhoto)" v-if="!isEditing"
          ><v-icon>mdi-delete</v-icon></v-btn
        >

        <v-form v-if="isEditing">
          <v-text-field
            label="タイトル"
            v-model="editedTitle"
            required
          ></v-text-field>
          <v-text-field label="説明" v-model="editedDescription"></v-text-field>
          <v-btn color="primary" @click="editPhoto">保存</v-btn>
          <v-btn @click="cancelEdit">キャンセル</v-btn>
        </v-form>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import generateQuery from "@/plugins/generateQuery";
import photosQuery from "@/pages/gqls/queries/Photos.gql";
import createPhotoMutation from "@/pages/gqls/mutations/CreatePhoto.gql";
import updatePhotoMutation from "@/pages/gqls/mutations/UpdatePhoto.gql";
import deletePhotoMutation from "@/pages/gqls/mutations/DeletePhoto.gql";

const getPhotosQuery = generateQuery(photosQuery);

export default {
  data() {
    return {
      photos: [],
      showCreateModal: false, // モーダルを表示するかどうかのフラグ
      newPhoto: {
        id: "",
        title: "",
        description: "",
      }, // 新規写真作成用データ
      showPhotoDetail: false,
      selectedPhoto: {},
      isEditing: false,
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
        const response = await this.$apollo.mutate({
          mutation: createPhotoMutation,
          variables: {
            title: this.newPhoto.title,
            description: this.newPhoto.description,
          },
        });
        console.log(response);
        this.newPhoto.id = response.data.createPhoto.photo.id;
        // 新しいPhotoを配列の先頭に追加
        this.photos.push(this.newPhoto);
        // モーダルを閉じる
        this.showCreateModal = false;
        // フォーム情報を初期化
        this.newPhoto = {
          id: "",
          title: "",
          description: "",
        };
      } catch (err) {
        console.log(err);
      }
    },
    showPhotoDetailModal(photo) {
      this.showPhotoDetail = true;
      this.selectedPhoto = photo;
    },
    prepareEdit() {
      this.isEditing = true;
      this.editedTitle = this.selectedPhoto.title;
      this.editedDescription = this.selectedPhoto.description;
    },
    cancelEdit() {
      this.isEditing = false;
    },
    async editPhoto() {
      try {
        await this.$apollo.mutate({
          mutation: updatePhotoMutation,
          variables: {
            id: this.selectedPhoto.id,
            title: this.editedTitle,
            description: this.editedDescription,
          },
        });
        this.selectedPhoto.title = this.editedTitle;
        this.selectedPhoto.description = this.editedDescription;
        // 編集フォームを閉じる
        this.cancelEdit();
      } catch (err) {
        console.error(err);
      }
    },
    async deletePhoto(photo) {
      try {
        await this.$apollo.mutate({
          mutation: deletePhotoMutation,
          variables: { id: photo.id },
        });
        this.photos = this.photos.filter((p) => p.id !== photo.id);
        this.showPhotoDetail = false;
      } catch (err) {
        console.error(err);
      }
    },
  },
  created() {
    this.getPhotos();
  },
};
</script>
