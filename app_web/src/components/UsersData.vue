<template>
  <div>
    <v-data-table :headers="headers" :items="users" item-key="id">
      <template v-slot:top>
        <v-toolbar flat>
          <h3>Utilisateurs</h3>
          <v-spacer></v-spacer>
          <v-dialog v-model="dialogDetails" max-width="700px">
            <v-card>
              <v-card-title class="align-center">
                Details de l'utilisateur
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col>
                      <v-avatar class="ml-14">
                        <img v-if="user.photoProfila != ''" :src="user.photoProfila" alt="../assets/default.png" />
                        <img v-else src="../assets/default.png" alt="../assets/default.png" />
                      </v-avatar>
                    </v-col>
                    <v-col>
                      <v-row>
                        ID : {{ user.id }}
                      </v-row>
                      <v-row>
                        Email : {{ user.email }}
                      </v-row>
                      <v-row>
                        Nom : {{ user.nom }}
                      </v-row>
                    </v-col>
                  </v-row>
                  <h3>Signalement envoyés :</h3>
                  <v-row>
                    <v-card v-for="s in sign" :key="s.id" class="cart" width="100%">
                      <v-col>
                        anomalie : {{ s.id }}
                      </v-col>
                      <v-col>
                        date signalement: {{ s.DateS }}
                      </v-col>
                      <v-col>
                        type : {{ s.type }}
                      </v-col>
                      <v-col>
                        etat: {{ s.etat }}
                      </v-col>
                    </v-card>
                  </v-row>
                </v-container>
              </v-card-text>
            </v-card>
          </v-dialog>
          <v-dialog v-model="dialogEdit" max-width="500px">
            <v-card>
              <v-card-title class="align-center">Edit User</v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-text-field label="Nom" v-model="user.nom"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="Email" v-model="user.email"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="numero de telephone" v-model="user.num_tel"></v-text-field>
                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions class="rounded-xl">
                <v-btn color="primary " text @click="closeEdit">Cancel</v-btn>
                <v-btn color="primary " @click="editUser(selectedId)">OK</v-btn>
                <v-spacer></v-spacer>
              </v-card-actions>
            </v-card>
          </v-dialog>
          <v-dialog v-model="dialogDelete" max-width="500px">
            <v-card>
              <v-card-title class="align-center">Are you sure you want to delete this item?</v-card-title>
              <v-card-actions class="rounded-xl">
                <v-spacer></v-spacer>
                <v-btn color="primary " text @click="closeDelete">Cancel</v-btn>
                <v-btn color="primary " @click="deleteUser(selectedId)">OK</v-btn>
                <v-spacer></v-spacer>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-toolbar>
      </template>
      <template v-slot:[`item.actions`]="{ item }">
        <v-icon color="blue" size="22" @click="editItem(item.id)"> mdi-pencil </v-icon>
        <v-icon color="red" size="22" @click="deleteItem(item.id)"> mdi-delete </v-icon>
        <v-icon color="green" size="22" @click="showDetails(item.id)">mdi-eye</v-icon>
      </template>
      <template v-slot:no-data>
        <h3 class="secondary--text">No DATA</h3>
      </template>
    </v-data-table>
  </div>
</template>


<script>
import supabase from '../supabase';

export default {
  name: "UsersData",
  data: () => ({
    dialog: false,
    dialogEdit: false,
    dialogDelete: false,
    dialogDetails: false,
    selectedId: null,
    modal: false,
    headers: [
      {
        text: "id",
        align: "start",
        sortable: false,
        value: "id",
      },
      { text: "Nom", value: "nom" },
      { text: "email", value: "email" },
      { text: "Telephone", value: "num_tel" },
      { text: "Actions", value: "actions", sortable: false },
    ],
    editedIndex: -1,
    users: [],
    user: {
      id: null,
      nom: "",
      email: "",
      num_tel: 0,
      photoProfila: null,
    },
    anomalies: [],
    sign: [],
    subscription: null,

  }),

  watch: {
    dialog(val) {
      val || this.close();
    },
    dialogDelete(val) {
      val || this.closeDelete();
    },
  },
  mounted() {
    this.getUsers()
    this.subscribe()
  },

  beforeDestroy() {
    this.unsubscribe()
  },

  methods: {

    subscribe() {
      this.subscription =
        supabase
          .channel('any')
          .on('postgres_changes', { event: '*', schema: 'public', table: 'Utilisateurs' }, payload => {
            console.log('Change received!', payload)
            this.getUsers();
          })
          .subscribe()
    },

    unsubscribe() {
      supabase.removeChannel(this.subscription)
    },

    async getUsers() {
      const { data, error } = await supabase.from('Utilisateurs').select();
      // console.log(data)
      if (error) {
        console.log(error)
      } else {
        this.users = data
        // console.log("success")
      }
    },

    //write a method to delete a user from the database using the id of the user 
    async deleteUser(id) {
      const { data, error } = await supabase.from('Utilisateurs').delete().eq('id', id);
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.$forceUpdate()
        this.closeDelete()
      }
    },

    //write a method to edit a user from the database using the id of the user
    async editUser(id) {
      const { data, error } = await supabase.from('Utilisateurs').update(
        {
          nom: this.user.nom,
          email: this.user.email,
          num_tel: this.user.num_tel,
        }
      ).eq('id', id);
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.$forceUpdate()
        this.closeEdit()
      }
    },

    //write a method to fetch a user by its id from the database
    async getUserById(id) {
      const { data, error } = await supabase.from('Utilisateurs').select().eq('id', id).single();
      if (error) {
        console.log(error)
      } else {
        console.log("success")
      }
      return data
    },


    async showDetails(id) {
      this.selectedId = id;
      this.dialogDetails = true;
      const { data: userData, error: userError } = await supabase.from('Utilisateurs').select().eq('id', id).single();
      if (userError) {
        console.log(userError)
      } else {
        console.log("success")
        this.user = userData
        console.log(this.user)


        const { data: anomaliesData, error: anomaliesError } = await supabase.from('multimedia').select().eq('idu', this.user.id);

        if (anomaliesError) {
          console.log(anomaliesError)
        } else {
          console.log("success22")
          this.anomalies = anomaliesData

          //get info from the signalement table by ids
          for (let i = 0; i < this.anomalies.length; i++) {
            const { data: signData, error: signError } = await supabase.from('signalement').select().eq('ids', this.anomalies[i].ids).single();
            if (signError) {
              console.log(signError)
            } else {
              console.log("success33")
              this.sign.push(signData)
              console.log(this.sign)
            }
          }

        }
      }
    },


    async editItem(id) {
      this.selectedId = id;
      this.dialogEdit = true;
      const { data, error } = await supabase.from('Utilisateurs').select().eq('id', id).single();
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.user = data
        console.log(this.user)
      }
    },




    deleteItem(id) {
      this.dialogDelete = true;
      this.selectedId = id;
    },

    close() {
      this.dialog = false;
    },

    closeDelete() {
      this.dialogDelete = false;
    },
    closeEdit() {
      this.dialogEdit = false;
    },



  },
};
</script>


<style>
.total {
  font-weight: bold;
  font-size: 1.2em;
  color: #000;
  display: flex;
  justify-content: flex-end;
  margin-right: 180px;
}

h3 {
  font-size: 1.2em;
  color: #000;
  display: flex;
  justify-content: center;
}
</style>