import discord
import os
import time

intents = discord.Intents.default()
intents.messages = True
intents.message_content = True  

bot = discord.Bot(intents=intents)

def embed(message: str):
    aliased = None
    if "twitter.com" in message and "vxtwitter" not in message and 'status' in message:
        aliased = message.replace("twitter.com", "vxtwitter.com")
    elif "x.com" in message and 'status' in message:
        aliased = message.replace("x.com", "vxtwitter.com")
    elif "instagram.com" in message and "instagramez.com" not in message and ('reels' in message or 'reel' in message):
        aliased = message.replace("instagram.com", "instagramez.com")
    return aliased

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return

    # Check if the message is from RSC
    if message.guild and message.guild.name == "Rush Site C":
        if "x.com" in message.content or "twitter.com" in message.content:
            try:
                await message.delete()
                await message.author.send(
                    f"Hi {message.author.name}, your message comes from a bad place (`twitter`).")
            except discord.Forbidden:
                with open("embed.log", 'a') as file:
                    now = time.time()
                    file.write(f"Could not send a DM to {message.author.name}.")
                    file.close()
            return



    aliased = embed(message.content)

    if aliased:
        #Handle the scenario for SFPJs
        #Check if the channel is not 
        if message.guild.name == "Squad Footie Pajamas" and message.channel != "brainrot":

            target_channel = discord.utils.get(message.guild.channels, name="brainrot")
            if target_channel:
                await target_channel.send(f"{message.author.display_name} shared: {aliased}")
                await message.delete()
        
        
        else:
            await message.channel.send(message.author.display_name + " shared: " + aliased)
        
        with open("embed.log", 'a') as file:
            now = time.time()
            file.write(f"{now}-{message.author.name}-{message.content}\n")
            file.close()



discord_key = os.environ.get('discord')

if discord_key is None:
    raise ValueError("discord environment variable is not set")

bot.run(discord_key)
