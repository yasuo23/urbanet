<template>
    <div>
        <v-data-table :headers="headers" :items="Propositions" item-key="id">
            <template v-slot:top>
                <v-toolbar flat>
                    <v-dialog v-model="dialogDetails" max-width="800px" class="d-flex align-center">
                        <v-card>
                            <v-card-title class="align-center">Details de l'anomalie</v-card-title>
                            <v-card-text>
                                <v-container class="d-flex">
                                    <v-col cols="6">
                                        <v-row>
                                            Date : {{ proposition.created_at }}
                                        </v-row>
                                        <v-row>
                                            Contenu : {{ proposition.contenu }}
                                        </v-row>
                                    </v-col>
                                    <v-col col="6">
                                        <v-img class="img" :src="proposition.image"></v-img>
                                    </v-col>
                                </v-container>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                    <!-- <v-dialog v-model="dialogEdit" max-width="700px">
                        <v-card>
                            <v-card-title class="align-center"> Modifier </v-card-title>
                            <v-card-text>
                                <v-container>
                                    
                                    <v-row>
                                        <v-btn primary @click="updateAnomaly(selectedId)">Modifier</v-btn>
                                    </v-row>
                                </v-container>
                            </v-card-text>
                        </v-card>
                    </v-dialog> -->
                    <v-dialog v-model="dialogDelete" max-width="500px">
                        <v-card>
                            <v-card-title class="align-center">Are you sure you want to delete this item?</v-card-title>
                            <v-card-actions class="rounded-xl">
                                <v-spacer></v-spacer>
                                <v-btn color="primary " text @click="closeDelete">Cancel</v-btn>
                                <v-btn color="primary " @click="deleteProposition(selectedId)">OK</v-btn>
                                <v-spacer></v-spacer>
                            </v-card-actions>
                        </v-card>
                    </v-dialog>
                </v-toolbar>
            </template>
            <template v-slot:[`item.actions`]="{ item }">
                <!-- <v-icon color="blue" size="22" @click="editItem(item.id)"> mdi-pencil </v-icon> -->
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
import supabase from '@/supabase.js';

export default {
    name: 'anomaliesData',
    data() {
        return {
            dialogEdit: false,
            dialogDelete: false,
            dialogDetails: false,
            selectedId: null,
            headers: [
                { text: 'ID', value: 'id' },
                { text: 'Date', value: 'created_at' },
                { text: 'Actions', value: 'actions', sortable: false },
            ],
            Propositions: [],
            proposition: {
                id: null,
                user: null,
                created_at: null,
                contenu: null,
                image: null,
            },
        
            updatedProposition: {
                etat: null,
                foncitonnaire: null
            },
        }
    },

    mounted() {
        this.getPropositions();
        this.getUser();
    },

    created() {

    },

    watch: {
        dialog(val) {
            val || this.close();
        },
        dialogDelete(val) {
            val || this.closeDelete();
        },

    },
    methods: {

        async getUser() {
            const { data: { user } } = await supabase.auth.getUser();
            this.updatedProposition.foncitonnaire = user.id
            console.log(this.updatedProposition.foncitonnaire)
        },

        async getPropositions() {
            const { data, error } = await supabase
                .from('proposition')
                .select('*')
            console.log(data)
            if (error) {
                console.log(error)
            } else {
                this.Propositions = data
                console.log("success")
            }
        },


        async deleteProposition(id) {
            const { data, error } = await supabase
                .from('proposition')
                .delete()
                .eq('id', id)
            if (error) {
                console.log(error)
            } else {
                console.log("success")
                this.closeDelete()
            }
        },

        async showDetails(id) {
            this.selectedId = id;
            this.dialogDetails = true;
            console.log(this.selectedId);

            const { data, error } = await supabase
                .from('proposition')
                .select()
                .eq('id', id)
                .single();
            if (error) {
                console.log(error)
            } else {
                this.proposition = data
                console.log("success")
            }
        },

        // method to  update the anomaly etat 
        async updateProposition(id) {
            const { data, error } = await supabase
                .from('proposition')
                .update({

                })
                .eq('id', id);

            console.log(data)
            if (error) {
                console.log(error)
                this.closeEdit()
            } else {
                console.log("success")
                this.closeEdit()
            }
        },

        deleteItem(id) {
            this.dialogDelete = true;
            this.selectedId = id;
        },
        closeDelete() {
            this.dialogDelete = false;
        },
        closeEdit() {
            this.dialogEdit = false;
        },
        editItem(id) {
            this.selectedId = id;
            this.dialogEdit = true;
        },
    }
}
</script>

<style scoped>
.img {
    width: 300px;
}

.det {
    margin-top: 25px;
    font-size: 20px;
    font-style: bold;
}

.align-center {
    align-items: center;
}
</style>