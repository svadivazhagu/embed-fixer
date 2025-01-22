import discord
import os
import time

intents = discord.Intents(messages=True)

bot = discord.Bot(intents=discord.Intents.all())

def embed(message:str):
    aliased = None
    if "twitter.com" in message and "vxtwitter" not in message and 'status' in message:
        aliased = message.replace("twitter.com", "vxtwitter.com")
    elif "x.com" in message and 'status' in message:
        aliased = message.replace("x.com", "vxtwitter.com")
    elif "instagram.com" in message and "instagramez.com" not in message and ('reels' in message or 'reel' in message):
        aliased = message.replace("instagram.com", "instagramez.com")
    #Tikok embed replacement no longer needed as Discord does it right
    # elif "tiktok.com" in message and "tiktxk" not in message:
    #     aliased = message.replace("tiktok", "tiktxk")
    return aliased
    

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return
    e = None
    e = embed(message.content)
    if e:
        await message.delete()

    with open("embed.log", 'a') as file:
        now = time.time()
        file.write(f"{now}-{message.author.name}-{aliased}\n") 

    print(f"{message.author.name} shared {aliased}")
    await message.channel.send(message.author.mention + " shared " + aliased)
    return

discord_key = os.environ.get('discord')

if discord_key is None:
    raise ValueError("discord environment variable is not set")

bot.run(discord_key)
