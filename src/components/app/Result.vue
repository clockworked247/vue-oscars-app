<template>
    <li class="list-group-item">
        <h4><a @click="viewDoc(result.uri)">{{ header }}</a></h4>
        <h6><a @click="viewDoc(result.uri)">{{ result.uri }}</a></h6>
        <p>
            Score: {{ result.score }}, 
            Confidence: {{ result.confidence }}
            Fitness: {{ result.fitness }}
        </p>
    </li>
</template>

<script>
    import {mapActions} from 'vuex';

    export default {
        props: ['result'],
        computed: { 
            header() {
                var film = _.filter(this.result.metadata, function(o) { return o.film !== undefined; })[0].film || '(film)';
                var name = _.filter(this.result.metadata, function(o) { return o.name !== undefined; })[0].name || '(name)';
                return '"' + film + '" - ' + name;
            }
        },
        methods: {
            ...mapActions([
                'getDoc'
            ]),
            viewDoc(uri) {
                this.getDoc(uri);
            }
        }
    }
</script>