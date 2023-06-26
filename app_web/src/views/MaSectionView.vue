<template>
  <div class="flexed-page">
      <div class="slider-container">
          <AppSlideBar />
      </div>
      <div class="main-content">
          <AppNavBar title="Signalement" />
          <v-card class="body1">
              <v-col>
                  <v-row>
                      ID : {{usern.id}}
                  </v-row>
                  <v-row>
                      Nom : {{usern.nom}}
                  </v-row>
                  <v-row>
                      Prenom : {{usern.prenom}}
                  </v-row>                    
              </v-col>
              <v-col>
                  <v-row>
                      Email : {{usern.email}}
                  </v-row>
                  <v-row>
                      Numéro de téléphone : {{usern.num_tel}}
                  </v-row>
              </v-col>
          </v-card>
          <FoncData class="body" />
      </div>
  </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import FoncData from "../components/FoncData.vue";

import supabase  from "../supabase";

export default {
  name: "signalements",
  components: {
      AppSlideBar,
      AppNavBar,
      FoncData,
  },

  data() {
      return {
          usern: {
              id: null,
              email: null,
              nom: null,
              prenom: null,
              num_tel: null,
          },
          user: null,
      }
  },


  mounted() {
      this.getUser();
      setTimeout(() => {
          this.getUsern();
      }, 1000);
  },

  methods: {
      async getUser() {
          const { data: { user } } = await supabase.auth.getUser();
          this.user = user
          console.log('tfff', this.user)
      },

      async getUsern() {
          const { data, error } = await supabase
              .from('fonctionnaires')
              .select('*')
              .eq('id', this.user.id)
              .single()
          if (error) {
              console.log(error)
          } else {
              this.usern = data
              console.log('nnnn', this.usern)
          }
      },
  },
};
</script>

<style scoped>
.flexed-page {
  height: 100%;
  display: flex;
}

.slider-container {
  height: 100%;
}

.main-content {
  width: 100%;
  height: 100%;
}

.body {
  margin: 40px 20px;
}

.body1 {
  margin: 0px 20px;
  padding: 18px;
  display: flex;
  height: 100px;
}
</style>