<template>
    <!-- I added only two links for now -->
    <v-navigation-drawer permanent expand-on-hover class="rounded-lg">
        <v-img :src="newLogo" class="newLogo logo"></v-img>
        <v-divider></v-divider>

        <v-list nav>
            <v-list-item to="/dashboard" exact-active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-view-dashboard</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Dashboard</v-list-item-title>
            </v-list-item>
            <v-list-item to="map" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-google-maps</v-icon>
                </v-list-item-icon>
                <v-list-item-title>MAP</v-list-item-title>
            </v-list-item>
            <v-list-item to="signalements" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-alert</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Signalements</v-list-item-title>
            </v-list-item>
            <v-list-item to="Propositions" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-note</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Propositions</v-list-item-title>
            </v-list-item>
            <v-list-item v-if="isAdmin" to="utilisateurs" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-account</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Gestion des Comptes</v-list-item-title>
            </v-list-item>
            <v-list-item to="MaSection" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-account</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Ma section</v-list-item-title>
            </v-list-item>
        </v-list>
        <div class="log">
            <v-divider></v-divider>
            <v-list-item to="/" active-class=" primary white--text">
                <v-list-item-icon>
                    <v-icon active-class="white">mdi-logout</v-icon>
                </v-list-item-icon>
                <v-list-item-title @click="logout">Logout</v-list-item-title>
            </v-list-item>
        </div>
    </v-navigation-drawer>
</template>
  
  
<script>
import supabase from '@/supabase';

export default {
    name: "AppSlideBar",
    data: () => ({
        oldLogo: require("../assets/logoApp.png"),
        newLogo: require("../assets/logoApp.png"),
        user: null,
        isAdmin: false,
    }),
    created() {
        this.checkRole();
    },
    methods: {
        logout() {
            supabase.auth.signOut();
            console.log("logout successful");
        },

        // async checkRole() {
        //     const { data: { user }, error } = await supabase.auth.getUser();
        //     if (error) {
        //         console.error("Error fetching user:", error);
        //         return;
        //     }

        //     this.user = user;
        //     console.log("Userjj:", this.user.id);

        //     // Check if user is in the table "admin"
        //     console.log("User ID:", this.user.id); // Check the value of user.id
        //     const { data: adminData, error: adminError } = await supabase
        //         .from("Admin")
        //         .select("*")
        //         .eq("id", this.user.id)
        //         .single();

        //     console.log("Admin Data:", adminData);
        //     if (adminError) {
        //         console.error("Error fetching admin data:", adminError);
        //         return;
        //     }

        //     // Set the "isAdmin" flag based on the presence of data in the "admin" table
        //     this.isAdmin = true;
        // }

        async checkRole(){
            const { data: { user }, error } = await supabase.auth.getUser();
            if (error) {
                console.error("Error fetching user:", error);
                return;
            }

            this.user = user;
            console.log("Userjj:", this.user.email);

            if (this.user.email == "admin@gmail.com") {
                this.isAdmin = true;
                return;
            }
            else {
                this.isAdmin = false;
            }
        }
    },
};
</script>
  
<style scoped>
.logo {
    transition: display 0.2s ease;
}

.oldLogo {
    display: block;
}

.newLogo {
    display: none;
    width: 150px;
    background-size: cover;
}

.v-navigation-drawer:hover .oldLogo {
    display: none;
}

.v-navigation-drawer:hover .newLogo {
    display: block;
}

.v-list-item {
    border-radius: 30px;
    margin-top: 8px;
}
</style>
  