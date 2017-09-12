<template>
    <div class="panel panel-default">
        <div class="panel-heading">Saved Queries</div>
        <div class="panel-body">
            <p>The list below are all the queries you have saved.</p>
            <p>You can delete or restore the saved query.</p>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>UUID #</th>
                    <th>Query</th>
                    <th colspan="2">Date Saved</th>
                </tr>
            </thead>
            <tbody>
                <app-query v-for="query in queries" :query="query"></app-query>
            </tbody>
        </table>
    </div>
</template>

<script>
    import Query from './Query.vue';

    export default {
        components: {
            appQuery: Query
        },
        computed: {
            queries() {
                return this.$store.getters.queries;
            }
        }
    }
</script>