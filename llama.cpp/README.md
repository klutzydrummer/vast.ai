# Brojack's easy use Llamacpp container!
{{template_title}}  
[Click Here to use!]({{template_url}})  

Simply run as is to run a container that pulls the latest version of llamacpp, downloads the GGUF model in the title, and then exposes a cloudflare tunnel.

I've gone through the trouble of finding a good configuration so you don't have to!

If you do want to make changes, I've done what I can to make that easy too!

Just edit the template!
- The '**MODEL_URL**' required variable points to the URL of the gguf you want.
- The '**MMPROJ_URL**' optional variable points to the URL of the multimodal projector gguf you want to use. (example: aifeifei798/Llama-3-Update-3.0-mmproj-model-f16)  
- The '**UI_ARGS_WITHOUT_MODEL**' variable contains the arguments you want llamacpp to run with.
- The '**CLOUDFLARE_TOKEN**' variable is an optional *advanced* setting variable, if you set it to a cloudflare tunnel token, the container will use the tunnel that corresponds to your token. Instructions for creating a tunnel can be found [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/). If you don't own your own domain, or don't understand what any of this means, then ignore this.

If running without the CLOUDFLARE_TOKEN variable set, then a cloudflare quick tunnel will be used.

Check the instance logs for the quick tunnel URL by searching for the following box with the URL in it:  
 +--------------------------------------------------------------------------------------------+  
 |  Your quick Tunnel has been created! Visit it at (it may take some time to be reachable):    
 |  https://example-example-example-example.trycloudflare.com                                         
 +--------------------------------------------------------------------------------------------+  

---

#### ARGS
**--ctx-size {{ctx}}** (Sets context to {{ctx_pretty}} tokens)  
**--n-gpu-layers {{num_layers}}** (Loads {{num_layers}} layers to gpu )  
**--host 0.0.0.0** (accepts all incoming ip connections regardless of origin )  
**--port {{port}}** (Sets TCP/IP port {{port}} as the port for incoming connections )  
**--mlock** (loads the model into RAM/VRAM and then prevents it from being unloaded)  
**--flash-attn** (uses flash attention)  
**--cache-type-k {{k_cache}}** (quantizes the keys in the kv cache [q8_0 shows minimal degredation])  
**--cache-type-v {{v_cache}}** (quantizes the values in the kv cache [q8_0 shows minimal degredation])  

---

#### Note
When picking a host on Vast.ai, remember that DLPerf roughly correlates with LLM generation speed, if slower speeds don't bother you feel free to experiment with saving money by choosing a smaller slower host.
