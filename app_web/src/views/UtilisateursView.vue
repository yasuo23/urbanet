<template>
    <div class="flexed-page">
        <div class="slider-container">
            <AppSlideBar />
        </div>
        <div class="main-content">
            <AppNavBar title="Gestion des Comptes" />
            <v-btn primary @click="toggleData">{{ this.button }}</v-btn>

            <v-btn @click="toggleDialog" v-if="buttonVal == 'Fonctionnaires'">Ajouter Fonctionnaire</v-btn>
            <v-dialog v-model="showDialog" max-width="600px">
                <v-card>
                    <v-card-title>Ajouter un fonctionnaire</v-card-title>
                    <v-card-text>
                        <v-text-field label="Email" v-model="form.email"></v-text-field>
                        <v-text-field label="Mot de passe" v-model="form.password" type="password"></v-text-field>
                        <v-text-field label="Nom" v-model="form.nom"></v-text-field>
                        <v-text-field label="Prénom" v-model="form.prenom"></v-text-field>
                        <v-text-field label="Numéro de téléphone" v-model="form.phoneNumber"></v-text-field>
                        <v-text-field label="Commune" v-model="form.commune"></v-text-field>
                    </v-card-text>
                    <v-card-actions>
                        <v-btn @click="addFonc">Ajouter</v-btn>
                        <v-btn @click="toggleDialog">Annuler</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <UsersData v-if="buttonVal == 'Utilisateurs'" class="body" />
            <WorkersData v-else class="body" />
        </div>
    </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import UsersData from "../components/UsersData.vue";
import WorkersData from "../components/WorkersData.vue";


import supabase from "../supabase";
import { createUser } from "@supabase/supabase-js";


export default {
    name: "utilisateurs",

    components: {
        AppSlideBar,
        AppNavBar,
        UsersData,
        WorkersData,
    },

    data() {
        return {
            buttonVal: 'Utilisateurs',
            showDialog: false,
            form: {
                nom: "",
                prenom: "",
                email: "",
                password: "",
                phoneNumber: "",
                commune: "",
            },
        }
    },

    computed: {
        button() {
            if (this.buttonVal == 'Utilisateurs') {
                return 'Fonctionnaires';
            } else {
                return 'Utilisateurs';
            }
        }
    },

    methods: {

        

        toggleData() {
            if (this.buttonVal == 'Utilisateurs') {
                this.buttonVal = 'Fonctionnaires';
            } else {
                this.buttonVal = 'Utilisateurs';
            }
        },

        toggleDialog() {
            this.showDialog = !this.showDialog;
            console.log('shiii');
        },

        async addFonc() {
            const { data, error } = await supabase.auth.admin.createUser({
                email: this.form.email,
                password: this.form.password,
            })

            if (error) {
                console.error("Error creating fonctionnaire:", error);
                // Handle error scenario here
                return;
            }

            console.log("Data:", JSON.stringify(data));
            const newUserId = data.user.id;

            //insert data into fonctionnaires table
            const { data: insertData, error: insertError } = await supabase
                .from("fonctionnaires")
                .insert({
                    id: newUserId,
                    email: this.form.email,
                    nom: this.form.nom,
                    prenom: this.form.prenom,
                    num_tel: this.form.phoneNumber,
                    commune: this.form.commune,
                });
            if (insertError) {
                console.error("Error adding fonctionnaire info:", insertError);
                // Handle error scenario here
                return;
            }
            console.log("fonctionnaire added successfully");
    },

        // async addFonctionnaire() {
        //     try {
        //         // Create the "fonctionnaire" account using Supabase signUp method
        //         const { user, error } = await supabase.auth.signUp({
        //             email: this.form.email,
        //             password: this.form.password,
        //         });

        //         if (error) {
        //             console.error("Error creating fonctionnaire:", error);
        //             // Handle error scenario here
        //             return;
        //         }

        //         // Retrieve the user information separately
        //         const { data, error: userError } = await supabase.auth.getUser();

        //         if (userError) {
        //             console.error("Error retrieving user information:", userError);
        //             // Handle error scenario here
        //             return;
        //         }

        //         // Get the fonctionnaire ID from the user information
        //         const fonctionnaireId = data?.id;

        //         if (!fonctionnaireId) {
        //             console.error("Error creating fonctionnaire: User ID is undefined");
        //             // Handle error scenario here
        //             return;
        //         }

        //         // Once the account is created, you can add additional information to the "fonctionnaires" table in Supabase

        //         // Create an object containing the additional information
        //         const fonctionnaireData = {
        //             id: fonctionnaireId,
        //             nom: this.form.nom,
        //             prenom: this.form.prenom,
        //             num_tel: this.form.phoneNumber,
        //             commune: this.form.commune,
        //         };

        //         // Insert the data into the "fonctionnaires" table
        //         const { data: insertData, error: insertError } = await supabase
        //             .from("fonctionnaires")
        //             .insert([fonctionnaireData]);

        //         if (insertError) {
        //             console.error("Error adding fonctionnaire info:", insertError);
        //             // Handle error scenario here
        //             return;
        //         }

        //         // Once the account is created, you can add additional information to the "fonctionnaire" table
        //         // in Supabase using the `user` object or perform any other necessary actions

        //         console.log("Fonctionnaire created:", data);

        //         // Reset the form fields if needed
        //         this.form.nom = "";
        //         this.form.prenom = "";
        //         this.form.email = "";
        //         this.form.password = "";
        //         this.form.phoneNumber = "";
        //         this.form.commune = "";

        //         // Close the dialog
        //         this.toggleDialog();
        //     } catch (error) {
        //         console.error("Error creating fonctionnaire:", error);
        //         // Handle error scenario here
        //     }
        // },




}

}
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

button {
    margin: 10px 10px 0px 20px;
}
</style>