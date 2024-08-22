package net.pickhaxe.compat.data.models;

#if forge
import net.minecraftforge.client.model.generators.ItemModelProvider as ForgeItemModelProvider;

import net.pickhaxe.datagen.DataGenerator.PickHaxeForgeItemModelProvider;
#end

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import net.minecraft.core.Holder;
import net.minecraft.data.models.ItemModelGenerators as VanillaItemModelGenerators;
import net.minecraft.data.models.ItemModelGenerators.TrimModelData;
import net.minecraft.data.models.model.ModelTemplate;
import net.minecraft.data.models.model.ModelTemplates;
import net.minecraft.data.models.model.TextureMapping;
import net.minecraft.data.models.model.TextureSlot;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.item.ArmorItem;
import net.minecraft.world.item.ArmorMaterial;
import net.minecraft.world.item.ArmorMaterials;
import net.minecraft.world.item.Item;
import net.minecraft.data.models.model.ModelLocationUtils;
import net.minecraft.data.models.model.TextureMapping;

class ItemModelGenerators
{
  public static var GENERATED_TRIM_MODELS(get, never):Array<TrimModelData>;

  static function get_GENERATED_TRIM_MODELS():Array<TrimModelData> {
    return net.pickhaxe.java.util.List.toArray(VanillaItemModelGenerators.GENERATED_TRIM_MODELS);
  }

  var vanillaGenerator:VanillaItemModelGenerators;

  #if fabric
  public function new(vanillaGenerator:VanillaItemModelGenerators) {
    this.vanillaGenerator = vanillaGenerator;
  }
  #end

  #if forge
  var itemModelProvider:Null<PickHaxeForgeItemModelProvider>;

  public function new(?itemModelProvider:PickHaxeForgeItemModelProvider) {
    this.itemModelProvider = itemModelProvider;
    this.vanillaGenerator = new VanillaItemModelGenerators(itemModelProvider.dataOutput);
  }
  #end

  public function generateFromTemplate(modelLocation:ResourceLocation, textureMapping:TextureMapping, modelTemplate:ModelTemplate):Void {
		#if fabric
    modelTemplate.create(modelLocation, textureMapping, vanillaGenerator.output);
    #else
    throw 'Not implemented';
    #end
  }

  public function getOutput():java.util.function.BiConsumer<ResourceLocation, java.util.function.Supplier<com.google.gson.JsonElement>> {
    #if fabric
    return this.vanillaGenerator.output;
    #else
    throw 'Not implemented';
    #end
  }

  public overload extern inline function generateFlatItem(item:Item, modelTemplate:ModelTemplate):Void {
    #if fabric
    this.vanillaGenerator.generateFlatItem(item, modelTemplate);
    #else
    throw 'Not implemented';
    #end
  }

  public overload extern inline function generateFlatItem(item:Item, modelLocationSuffix:String, modelTemplate:ModelTemplate):Void {
    #if fabric
    this.vanillaGenerator.generateFlatItem(item, modelLocationSuffix, modelTemplate);
    #else
    throw 'Not implemented';
    #end
  }

  public overload extern inline function generateFlatItem(item:Item, layerZeroItem:Item, modelTemplate:ModelTemplate):Void {
    #if fabric
    this.vanillaGenerator.generateFlatItem(item, layerZeroItem, modelTemplate);
    #else
    throw 'Not implemented';
    #end
  }

  public function generateItemWithOverlay(item:Item):Void {
    #if fabric
    this.vanillaGenerator.generateItemWithOverlay(item);
    #else
    throw 'Not implemented';
    #end
  }

  /**
   * Generate a flat item with multiple frames.
   * For example, a compass has 32 frames and a clock has 64.
   * @param item The `Item` to generate from.
   * @param frameCount The number of frames to generate. For example, `32` generates frames 0 to 31.
   * @param skipFrames An array of frames to skip. For example, `[16]` skips frame 16.
   */
  public function generateMultiFrameItem(item:Item, frameCount:Int, ?skipFrames:Array<Int>):Void {
    if (skipFrames == null) skipFrames == [];

    for (i in 0...frameCount) {
      if (!skipFrames.contains(i)) {
        this.generateFlatItem(item, '_${'${i}'.lpad('0', 2)}', ModelTemplates.FLAT_ITEM);
      }
    }
  }

  public function generateCompassItem(item:Item):Void {
    return this.generateMultiFrameItem(item, 32, [16]);
  }

  public function generateClockItem(item:Item):Void {
    return this.generateMultiFrameItem(item, 64);
  }

  public overload extern inline function generateLayeredItem(modelLocation:ResourceLocation, layer0:ResourceLocation, layer1:ResourceLocation) {
    this.vanillaGenerator.generateLayeredItem(modelLocation, layer0, layer1);
	}

	public overload extern inline function generateLayeredItem(modelLocation:ResourceLocation, layer0:ResourceLocation, layer1:ResourceLocation, layer2:ResourceLocation) {
    this.vanillaGenerator.generateLayeredItem(modelLocation, layer0, layer1, layer2);
	}

  public function getItemModelForTrimMaterial(id:ResourceLocation, trimMaterialName:String):ResourceLocation {
    return this.vanillaGenerator.getItemModelForTrimMaterial(id, trimMaterialName);
  }

  public function generateBaseArmorTrimTemplate(modelLocation:ResourceLocation, textures:java.util.Map<TextureSlot, ResourceLocation>,
    armorMaterial:Holder<ArmorMaterial>):com.google.gson.JsonObject {
    return this.vanillaGenerator.generateBaseArmorTrimTemplate(modelLocation, textures, armorMaterial);
  }

  public function generateArmorTrims(item:ArmorItem):Void {
    this.vanillaGenerator.generateArmorTrims(item);
  }

  public overload extern inline function register(item:Item, modelTemplate:ModelTemplate):Void {
    generateFlatItem(item, modelTemplate);
  }

  public overload extern inline function register(item:Item, modelLocationSuffix:String, modelTemplate:ModelTemplate):Void {
    generateFlatItem(item, modelLocationSuffix, modelTemplate);
  }

  public overload extern inline function register(item:Item, layerZeroItem:Item, modelTemplate:ModelTemplate):Void {
    generateFlatItem(item, modelTemplate);
  }

  public function registerWolfArmor(item:Item):Void {
    generateItemWithOverlay(item);
  }

  public function registerCompass(item:Item):Void {
    generateCompassItem(item);
  }

  public function registerClock(item:Item):Void {
    generateClockItem(item);
  }

  public overload extern inline function uploadArmor(id:ResourceLocation, layer0:ResourceLocation, layer1:ResourceLocation):Void {
    generateLayeredItem(id, layer0, layer1);
  }

  public overload extern inline function uploadArmor(id:ResourceLocation, layer0:ResourceLocation, layer1:ResourceLocation, layer2:ResourceLocation):Void {
    generateLayeredItem(id, layer0, layer1, layer2);
  }

  public function suffixTrim(id:ResourceLocation, trimMaterialName:String):ResourceLocation {
    return getItemModelForTrimMaterial(id, trimMaterialName);
  }

  public function createArmorJson(modelLocation:ResourceLocation, textures:java.util.Map<TextureSlot, ResourceLocation>,
    armorMaterial:Holder<ArmorMaterial>):com.google.gson.JsonObject {
    return generateBaseArmorTrimTemplate(modelLocation, textures, armorMaterial);
  }

  public function registerArmor(item:ArmorItem):Void {
    generateArmorTrims(item);
  }

  /**
   * Generate the base armor trim template, but with an argument for the trim data to allow for generating custom trim materials.
   * @param modelLocation 
   * @param textures 
   * @param trimModelData 
   */
  public function generateCustomBaseArmorTrimTemplate(modelLocation:ResourceLocation, textures:java.util.Map<TextureSlot, ResourceLocation>,
    armorMaterial:Holder<ArmorMaterial>, trimModelData:Array<TrimModelData>):JsonObject {
    // { "parent": "minecraft:item/generated", "overrides": [] }
    var result:JsonObject = ModelTemplates.TWO_LAYERED_ITEM.createBaseTemplate(modelLocation, textures);

    var overrides:JsonArray = new JsonArray();

    for (trimModel in trimModelData) {
      // { "model": model_resource_location, "predicate": { "trim_type": trim_model_index } }

      var modelOverride:JsonObject = new JsonObject();
      var modelData = this.getItemModelForTrimMaterial(modelLocation, trimModel.name(armorMaterial)).toString();
      modelOverride.addProperty("model", modelData);

      var predicate:JsonObject = new JsonObject();
      var predicateNumber:java.lang.Number = java.lang.Float.fromFloat(trimModel.itemModelIndex());
      predicate.addProperty("trim_type", predicateNumber);

      modelOverride.add("predicate", predicate);

      overrides.add(modelOverride);
    }

    result.add("overrides", overrides);
    return result;
  }

  /**
   * Generate a custom armor item, but with an argument for the trim data to allow for generating custom trim materials.
   * @param item The armor item to generate.
   * @param trimModelData The trim data to use.
   * @param forceTwoLayer Optionally force the item to be two layered (like Leather).
   */
  public function generateCustomArmorItem(item:ArmorItem, trimModelData:Array<TrimModelData>, forceTwoLayer:Bool = false):Void {
    var trimTemplateGenerator:net.minecraft.data.models.model.ModelTemplate.ModelTemplate_JsonFactory =
      generateCustomBaseArmorTrimTemplate.bind(_, _, item.getMaterial(), trimModelData);

    var isTwoLayered = forceTwoLayer || item.getMaterial().is(ArmorMaterials.LEATHER);

    if (isTwoLayered) {
      ModelTemplates.TWO_LAYERED_ITEM.create(
        ModelLocationUtils.getModelLocation(item),
        TextureMapping.layered(TextureMapping.getItemTexture(item), TextureMapping.getItemTexture(item, "_overlay")),
        getOutput(),
        trimTemplateGenerator
      );
    } else {
      ModelTemplates.FLAT_ITEM.create(
        ModelLocationUtils.getModelLocation(item),
        TextureMapping.layer0(TextureMapping.getItemTexture(item)),
        getOutput(),
        trimTemplateGenerator
      );
    }

    for (trimModel in trimModelData) {
      if (isTwoLayered) {
        this.generateLayeredItem(
          getItemModelForTrimMaterial(ModelLocationUtils.getModelLocation(item), trimModel.name(item.getMaterial())),
          TextureMapping.getItemTexture(item),
          TextureMapping.getItemTexture(item, "_overlay"),
          ResourceLocation.withDefaultNamespace('${item.getType().getName()}_trim_${trimModel.name(item.getMaterial())}').withPrefix("trims/items/")
        );
      } else {
        this.generateLayeredItem(
          getItemModelForTrimMaterial(ModelLocationUtils.getModelLocation(item), trimModel.name(item.getMaterial())),
          TextureMapping.getItemTexture(item),
          ResourceLocation.withDefaultNamespace('${item.getType().getName()}_trim_${trimModel.name(item.getMaterial())}').withPrefix("trims/items/")
        );
      }
    }
  }
}