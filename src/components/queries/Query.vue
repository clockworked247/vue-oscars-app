<template>
    <tr>
        <th scope="row">{{ query.id }}</th>
        <td>{{ query.query }}</td>
        <td>{{ dateString }}</td>
        <td>
            <div class="btn-group" role="group" aria-label="Default button group"> 
                <button type="button" class="btn btn-success btn-xs" @click="restoreQuery(query)">
                    <span class="glyphicon glyphicon-search" title="search"></span>
                </button> 
                <button type="button" class="btn btn-danger btn-xs" @click="deleteQuery(query)">
                    <span class="glyphicon glyphicon-remove" title="delete"></span>
                </button> 
            </div>
        </td>
    </tr>
</template>

<style scoped>
    .danger {
        border: 1px solid red;
    }
</style>

<script>
    import moment from 'moment';

    export default {
        props: ['query'],
        computed: {
          dateString() {
              return moment(this.query.date).format('MMMM Do YYYY, h:mm:ss a');
          } 
        },
        methods: {
            deleteQuery(query) {
                this.$store.dispatch('deleteQuery', query); // TODO
            },
            restoreQuery(query) {
                this.$store.dispatch('updateCurrentQuery', query.query); // TODO
                this.$router.push('/app')
            }
        }
    }
</script>