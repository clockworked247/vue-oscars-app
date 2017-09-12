<template>
    <a class="close" @click="clearDoc">close</a>
    <div class="content">
        <pre><code>
        {{ doc }}
        </code></pre>
    </div>
</template>

<style>
    .close {
        float:right;
    }
</style>

<script>
    import pd from 'pretty-data';
    import {mapActions} from 'vuex';

    export default {
        props: ['doc'],
        computed: { 
            content() {
                // return pd.xml(doc)
                return doc
            }
        },
        methods: {
            ...mapActions([
                'clearDoc'
            ])
        }
    }
</script>