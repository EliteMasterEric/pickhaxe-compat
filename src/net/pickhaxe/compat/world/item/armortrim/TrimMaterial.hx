package net.pickhaxe.compat.world.item.armortrim;

import net.minecraft.world.item.ArmorMaterial;
import net.minecraft.world.item.armortrim.TrimMaterial as TrimMaterial_Minecraft;
import net.minecraft.core.registries.Registries;
import net.pickhaxe.compat.world.item.Item;
import net.minecraft.network.chat.Component;
import net.minecraft.Util;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceKey;
import net.minecraft.network.chat.Style;
import net.minecraft.data.models.ItemModelGenerators.TrimModelData;

/**
 * A wrapper around the Trim Material class,
 * providing a convenient cross-loader API for creating and registering new Trim Materials.
 */
@:forward
abstract TrimMaterial(TrimMaterial_Minecraft) from TrimMaterial_Minecraft to TrimMaterial_Minecraft
{
  public static final DIRECT_CODEC(get, never):com.mojang.serialization.Codec<net.minecraft.world.item.armortrim.TrimMaterial>;

  static function get_DIRECT_CODEC():com.mojang.serialization.Codec<net.minecraft.world.item.armortrim.TrimMaterial>
  {
    return TrimMaterial_Minecraft.DIRECT_CODEC;
  }

  public static final CODEC(get, never):com.mojang.serialization.Codec<net.minecraft.core.Holder<net.minecraft.world.item.armortrim.TrimMaterial>>;

  static function get_CODEC():com.mojang.serialization.Codec<net.minecraft.core.Holder<net.minecraft.world.item.armortrim.TrimMaterial>>
  {
    return TrimMaterial_Minecraft.CODEC;
  }

  /**
   * Build a new trim material.
   * @param ingredient The item to use as a material.
   * @param itemModelIndex The internal model index to use. Choose a unique floating point number.
   * @param color The color of the trim material. Used in the description of items with this material.
   * @param assetName The name for the trim material. Defaults to the name of the ingredient.
   */
  public static function build(ingredient:Item, itemModelIndex:Single, color:Int, resourceLocation:net.minecraft.resources.ResourceLocation,
      ?overrideArmorMaterials:Map<ArmorMaterial, String>):TrimMaterial
  {
    var resourceKey = ResourceKey.create(Registries.TRIM_MATERIAL, resourceLocation);

    var description = Component.translatable(Util.makeDescriptionId("trim_material", resourceKey.location())).withStyle(Style.EMPTY.withColor(color));

    var overrideArmorMaterialsJava = net.pickhaxe.java.util.Map.of(overrideArmorMaterials);

    // asset_name, ingredient, item_model_index, description, override_armor_materials
    return TrimMaterial_Minecraft.create(resourceLocation.getPath(), ingredient, itemModelIndex, description, overrideArmorMaterialsJava);
  }

  public function buildModel():TrimModelData {
    return new TrimModelData(this.assetName(), this.itemModelIndex(), this.overrideArmorMaterials());
  }
}
