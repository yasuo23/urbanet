<template>
    <!-- This is a navbar -->
    <v-app-bar color="white mb-2" flat>
        <v-toolbar-title>{{ title }}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn icon>
            <v-icon>mdi-bell</v-icon>
        </v-btn>
        <v-avatar class="ml-4">
            <img src="../assets/default.png" alt="John" />
        </v-avatar>
    </v-app-bar>
</template>
  
<script>
export default {
    name: "AppNavBar",
    props: {
        title: {
            type: String,
            default: "Concept",
        },
    },
    data: () => ({
        userName: "Mahdi"
    }),
};

</script>