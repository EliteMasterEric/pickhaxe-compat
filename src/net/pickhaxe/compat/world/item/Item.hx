package net.pickhaxe.compat.world.item;

import net.minecraft.resources.ResourceLocation;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.item.Item as Item_Minecraft;

/**
 * Add new convenience and compatibility functions to the Item class.
 */
@:forward // Forward all fields and methods
abstract Item(Item_Minecraft) from Item_Minecraft to Item_Minecraft
{
  /**
   * Alias to the real constructor.
   */
  public inline function new(props:net.minecraft.world.item.Item.Item_Properties) {
    this = new Item_Minecraft(props);
  }

  /**
   * Register this item into the game's Item registery.
   * @param resourceLocation The resource location to register this item under.
   *                         Remember to include your mod ID in the namespace.
   * @return Self, for chaining.
   */
  public inline function register(resourceLocation:ResourceLocation):Item
  {
    #if fabric
    net.pickhaxe.compat.core.Registries.ITEMS.register(resourceLocation, this);
    #elseif forge
    Item_ForgeRegistrar.queueItem(resourceLocation, this);
    #end

    // Chainable.
    return this;
  }

  /**
   * Get the resource key for this item, corresponding to its location in the item registry.
   */
  public function getKey():ResourceKey<net.minecraft.world.item.Item> {
    return this.builtInRegistryHolder().key();
  }
}

#if forge
/**
 * Handles deferred item registration on Minecraft Forge.
 */
class Item_ForgeRegistrar extends net.pickhaxe.compat.forge.ForgeRegistrar<Item_Minecraft>
{
  static var instance:Item_ForgeRegistrar = new Item_ForgeRegistrar();

  public override function buildTargetRegistryKey():net.minecraft.resources.ResourceKey<net.minecraft.core.Registry<net.minecraft.world.item.Item>>
  {
    return net.minecraftforge.registries.ForgeRegistries.ForgeRegistries_Keys.ITEMS;
  }

  public static function register(eventBus:net.minecraftforge.eventbus.api.IEventBus):Void
  {
    net.pickhaxe.core.PickHaxe.logDebug('Registering Item_ForgeRegistrar lifecycle listeners...');
    // This is safe to run multiple times.
    eventBus.register(instance);
  }

  public static function queueItem(resourceLocation:ResourceLocation, item:Item_Minecraft):Item_Minecraft
  {
    // Chainable.
    net.pickhaxe.core.PickHaxe.logInfo("Queued Item: " + resourceLocation);
    return instance.queue(resourceLocation, item);
  }

  #if minecraft_lt_1_19
  @:strict(net.minecraftforge.eventbus.api.SubscribeEvent())
  public function onRegister(event:net.minecraftforge.event.RegistryEvent.Register<Item_Minecraft>):Void {
    onRegisterEntries(event.getRegistry());
  }

  override function applyEntryId(key:ResourceLocation, value:Item_Minecraft) {
    value.setRegistryName(key);
  }
  #end

  public override function toString():String
  {
    return "ForgeRegistrar<Item>";
  }
}
#end
