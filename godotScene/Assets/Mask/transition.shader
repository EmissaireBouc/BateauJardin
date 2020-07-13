/* Pour en savoir plus sur le fonctionnement du shader : 
	https://www.youtube.com/watch?v=LAa8UE3ItM8&list=PLhqJJNjsQ7KHqNMYmTwtsYTeTrqrRP_fP&index=10 
	https://thebookofshaders.com/
*/

shader_type canvas_item;
render_mode unshaded ; /* unshaded : ne sera pas affecté par la lumière */

uniform float cutoff : hint_range(0.0,1.0); /* entre 0-1 indique la progression de la transition, entre les pixels visibles (1) invisible (0) et transparent (0.1-0.99) */
uniform float smooth_size : hint_range(0.0,1.0);
uniform sampler2D mask : hint_albedo;

uniform vec4 color : hint_color;

void fragment(){
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	COLOR = vec4(COLOR.rgb, alpha);
}