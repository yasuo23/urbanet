<template>
  <div>
    <v-data-table :headers="headers" :items="fonctionnaires" item-key="id">
      <template v-slot:top>
        <v-toolbar flat>
          <h3>fonctionnaires</h3>
          <v-spacer></v-spacer>
          <v-dialog v-model="dialogDetails" max-width="700px">
            <v-card>
              <v-card-title class="align-center">
                Details du fonctionnaire
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col>
                      <v-avatar class="ml-14">
                        <img src="../assets/default.png" alt="John" />
                      </v-avatar>
                    </v-col>
                    <v-col>
                      <v-row>
                        ID : {{ fonctionnaire.id }}
                      </v-row>
                      <v-row>
                        Nom : {{ fonctionnaire.nom }}
                      </v-row>
                      <v-row>
                        Prenom : {{ fonctionnaire.prenom }}
                      </v-row>
                      <v-row>
                        Email : {{ fonctionnaire.email }}
                      </v-row>
                      <v-row>
                        Commune : {{ fonctionnaire.commune }}
                      </v-row>
                      <v-row>
                        Telephone : {{ fonctionnaire.num_tel }}
                      </v-row>
                    </v-col>
                  </v-row>
                  <h3>Signalement traités :</h3>
                  <v-row>
                    <v-card class="cart" width="100%" v-for="an in anomalies" :key="an.ids">
                      <v-col>
                        anomalie : {{ an.ids }}
                      </v-col>
                      <v-col>
                        date : {{ an.DateT }}
                      </v-col>
                      <v-col>
                        typy : {{ an.type }}
                      </v-col>
                      <v-col>
                        etat: {{ an.etat }}
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
                    <v-text-field label="Nom" v-model="fonctionnaire.nom"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="Prenom" v-model="fonctionnaire.prenom"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="Email" v-model="fonctionnaire.email"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="Telephone" v-model="fonctionnaire.num_tel"></v-text-field>
                  </v-row>
                  <v-row>
                    <v-text-field label="Commune" v-model="fonctionnaire.commune"></v-text-field>
                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions class="rounded-xl">
                <v-btn color="primary " text @click="closeEdit">Cancel</v-btn>
                <v-btn color="primary " @click="editF(selectedId)">OK</v-btn>
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
                <v-btn color="primary " @click="deleteF(selectedId)">OK</v-btn>
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
  name: "FonctionnairesData",
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
      // { text: "Nom", value: "nom" },
      { text: "email", value: "email" },
      { text: "Nom", value: "nom" },
      { text: "Prenom", value: "prenom" },
      { text: "Commune", value: "commune" },
      { text: "Telephone", value: "num_tel" },
      { text: "Actions", value: "actions", sortable: false },
    ],
    editedIndex: -1,
    fonctionnaires: [],
    anomalies: [],
    fonctionnaire: {
      id: null,
      nom: null,
      prenom: null,
      email: null,
      num_tel: null,
      commune: null,
    },
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
    this.getFonctionnaires()
    this.subscribe()
  },

  destroyed() {
    this.unsubscribe()
  },

  methods: {

    subscribe() {
            this.subscription =
                supabase
                    .channel('any')
                    .on('postgres_changes', { event: '*', schema: 'public', table: 'fonctionnaires' }, payload => {
                        console.log('Change received!', payload)
                        this.getFonctionnaires();
                    })
                    .subscribe()

        },

        unsubscribe() {
            supabase.removeChannel(this.subscription)
        },

    async getFonctionnaires() {
      const { data, error } = await supabase.from('fonctionnaires').select("*");
      console.log(data)
      if (error) {
        console.log(error)
      } else {
        this.fonctionnaires = data
        console.log("success")
      }
    },

    //write a method to delete a user from the database using the id of the user 
    async deleteF(id) {
      const { data, error } = await supabase.from('fonctionnaires').delete().eq('id', id);
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.closeDelete()
      }
    },

    //write a method to edit a user from the database using the id of the user
    async editF(id) {
      const { data, error } = await supabase.from('fonctionnaires').update(
        {
          nom: this.fonctionnaire.nom,
          prenom: this.fonctionnaire.prenom,
          email: this.fonctionnaire.email,
          num_tel: this.fonctionnaire.num_tel,
          commune: this.fonctionnaire.commune,
        }
      ).eq('id', id);
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.closeEdit()
      }
    },

    //write a method to fetch a user by its id from the database
    async getUserById(id) {
      const { data, error } = await supabase.from('fonctionnaires').select().eq('id', id).single();
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
      const { data: workerData, error: workerError } = await supabase.from('fonctionnaires').select().eq('id', id).single();
      if (workerError) {
        console.log(workerError)
      } else {
        console.log("success 11")
        this.fonctionnaire = workerData
        console.log(this.fonctionnaire)

        const { data: anomaliesData, error: anomaliesError } = await supabase.from('signalement').select().eq('idF', this.fonctionnaire.id);
        if (anomaliesError) {
          console.log(anomaliesError)
        } else {
          console.log("success 22")
          this.anomalies = anomaliesData
          console.log(this.anomalies)
        }
      }
    },

    async editItem(id) {
      this.selectedId = id;
      this.dialogEdit = true;
      const { data, error } = await supabase.from('fonctionnaires').select().eq('id', id).single();
      if (error) {
        console.log(error)
      } else {
        console.log("success")
        this.fonctionnaire = data
        console.log(this.fonctionnaire)
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

.cart {
  display: flex;
  justify-content: flex-end;
  margin-top: 8px;
}

h3 {
  margin: 20px 0px;

  color: #000;
  font-weight: bold;
}
</style>