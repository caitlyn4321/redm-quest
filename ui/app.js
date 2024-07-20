const { createApp } = Vue;

const app = createApp({
    data() {
        return {
            page: 0, 
            meta : null,
        };
    },
    methods: {
        handleMessage(event) {
            if (event.data.type === 'display') {
                this.page = 1;
                console.log("display");
            }
            if (event.data.meta) {
                this.meta = event.data.meta;
                console.table(this.meta);
            }
        },
        handleKeydown(event) {
            // Handle keydown event here
            if (event.key === 'Escape') {
                this.close(null);
            }
        },
        close(data) {
            this.page = 0;

            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
    },
    mounted() {
        window.addEventListener('message', this.handleMessage);
        window.addEventListener('keydown', this.handleKeydown);
    },
    unmounted() {
        window.removeEventListener('message', this.handleMessage);
        window.removeEventListener('keydown', this.handleKeydown);
    }
});

app.mount('#app');