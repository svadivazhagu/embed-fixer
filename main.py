import discord
import os
import time

intents = discord.Intents(messages=True)

bot = discord.Bot(intents=discord.Intents.all())

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return

    aliased = None
    if "twitter.com" in message.content and "vxtwitter" not in message.content and 'status' in message.content:
        aliased = message.content.replace("twitter.com", "vxtwitter.com")
    elif "x.com" in message.content and 'status' in message.content:
        aliased = message.content.replace("x.com", "vxtwitter.com")
    elif "instagram.com" in message.content and "instagramez.com" not in message.content and ('reels' in message.content or 'reel' in message.content):
        aliased = message.content.replace("instagram.com", "instagramez.com")
    #Tikok embed replacement no longer needed as Discord does it right
    # elif "tiktok.com" in message.content and "tiktxk" not in message.content:
    #     aliased = message.content.replace("tiktok", "tiktxk")

    if aliased:
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
