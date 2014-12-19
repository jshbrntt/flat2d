package
{
    import flash.utils.ByteArray;

    import flat2d.core.FlatGame;
    import flat2d.core.FlatWorld;
    import flat2d.effects.Explode;
    import flat2d.effects.Fragile;
    import flat2d.entities.FlatBox;
    import flat2d.entities.FlatEntity;
    import flat2d.entities.FlatHandJoint;
    import flat2d.utils.BodyAtlas;
    import flat2d.utils.InteractionManager;
    import flat2d.utils.Key;
    import flat2d.utils.KeyManager;

    import nape.geom.Vec2;
    import nape.geom.Vec2List;
    import nape.phys.BodyType;
    import nape.shape.Polygon;

    import starling.display.Image;
    import starling.filters.BlurFilter;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    /**
     * ExampleWorld.as
     * Created On:    22/01/2013 20:26
     * Author:        Joshua Barnett
     */

    public class ExampleWorld extends FlatWorld
    {
        [Embed(source="../assets/physics.json", mimeType="application/octet-stream")]
        private const _physicsJSON:Class;
        [Embed(source="../../logo/logo.png")]
        private const _logoPNG:Class;
        [Embed(source="../assets/landscape.png")]
        private const _landscapePNG:Class;
        [Embed(source="../assets/pad.png")]
        private const _padPNG:Class;
        [Embed(source="../assets/button.png")]
        private const _buttonPNG:Class;
        [Embed(source="../assets/cradle.png")]
        private const _cradlePNG:Class;

        private var _player:ExamplePlayer;
        private var _landscape:FlatEntity;
        private var _pad:FlatEntity;
        private var _button:FlatEntity;
        private var _objects:Vector.<FlatEntity>;
        private var _handJoint:FlatHandJoint;
        private var _bodyAtlas:BodyAtlas;
        private var _pentagon:Explode;

        public function ExampleWorld(game:FlatGame)
        {
            super(game, new Vec2(0, 600));
        }

        override public function update():void
        {
            super.update();
        }

        override public function dispose():void
        {
            KeyManager.removePressed(Key.P, togglePause);
            KeyManager.removePressed(Key.D, toggleDebug);
            InteractionManager.dispose();
            _player = null;
            _landscape = null;
            _pad = null;
            _objects.length = 0;
            _objects = null
            super.dispose();
        }

        override protected function initialize():void
        {
            super.initialize();

            _bodyAtlas = new BodyAtlas(ByteArray(new _physicsJSON).toString());

            KeyManager.pressed(Key.P, togglePause);
            KeyManager.pressed(Key.D, toggleDebug);

            createInfo();
            createHandJoint();
            createObjects(5, 20, 40);
            createLandscape();
            createPlayer();
            createPad();
            createButton();
            createFrame();
            createInteractions();

            _pentagon = new Explode(stage.stageWidth / 2, stage.stageHeight / 2, _bodyAtlas.getHull("cradle"), null, false, 0x00FF00);
            _pentagon.body.type = BodyType.STATIC;
            _pentagon.view = new Image(Texture.fromBitmap(new _cradlePNG));
            _pentagon.view.pivotX = _pentagon.view.width / 2;
            _pentagon.view.pivotY = _pentagon.view.height / 2;
            addEntity(_pentagon);
        }

        private function createInfo():void
        {
            var logo:Image = new Image(Texture.fromBitmap(new _logoPNG));
            logo.x = stage.stageWidth / 2 - logo.width / 2;
            addChildAt(logo, 0);

            var infoText:String = "P = Pause\n" + "D = Debug Draw\n" + "Left/Right = Movement\n" + "Up = Jump";

            var infoField:TextField = new TextField(300, 200, infoText, "Verdana", 18, 0x000000);
            infoField.x = 20;
            infoField.y = 20;
            infoField.hAlign = HAlign.LEFT;
            infoField.vAlign = VAlign.TOP;
            addChild(infoField);
        }

        private function createHandJoint():void
        {
            _handJoint = new FlatHandJoint(space);
        }

        private function createObjects(num:int = 10, min:Number = 20, max:Number = 40):void
        {
            _objects = new Vector.<FlatEntity>();

            for (var i:int = 0; i < num; ++i)
            {
                _objects.push(addEntity(new Fragile(randLim(100, 700), 100, Vec2List.fromArray(Polygon.regular(randLim(min, max), randLim(min, max), int(randLim(3, 9)))), null, false, Math.random() * 0xFFFFFF)));
            }

            function randLim(min:Number, max:Number):Number
            {
                return min + Math.random() * (max - min);
            }
        }

        private function createLandscape():void
        {
            _landscape = new FlatEntity(stage.stageWidth / 2, stage.stageHeight / 2, null);
            _landscape.body = _bodyAtlas.getBody("landscape");
            _landscape.view = new Image(Texture.fromBitmap(new _landscapePNG))
            _landscape.view.pivotX = _landscape.view.width / 2;
            _landscape.view.pivotY = _landscape.view.height / 2;
            addEntity(_landscape);
        }

        private function createPlayer():void
        {
            _player = new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 4);
            _player.worldView = view;
            addEntity(_player);
        }

        private function createPad():void
        {
            _pad = new FlatEntity(380, 580, new Image(Texture.fromBitmap(new _padPNG)));
            _pad.body = _bodyAtlas.getBody("pad");
            _pad.view.pivotX = _pad.view.width / 2;
            _pad.view.pivotY = _pad.view.height / 2;
            addEntity(_pad);
        }

        private function createButton():void
        {
            _button = new FlatEntity(16, 400, new Image(Texture.fromBitmap(new _buttonPNG)));
            _button.body = _bodyAtlas.getBody("button");
            _button.view.pivotX = _button.view.width / 2;
            _button.view.pivotY = _button.view.height / 2;
            addEntity(_button);
        }

        private function createFrame():void
        {
            var size:Number = 10;
            var left:FlatBox = new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight, null, true, 0x000000);
            var right:FlatBox = new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight, null, true, 0x000000);
            var up:FlatBox = new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size, null, true, 0x000000);
            var down:FlatBox = new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size, null, true, 0x000000);

            var frame:Vector.<FlatBox> = Vector.<FlatBox>([left, right, up, down]);

            for each (var side:FlatBox in frame)
            {
                side.body.type = BodyType.STATIC;
                addEntity(side);
            }
        }

        private function createInteractions():void
        {
            InteractionManager.initialize(space);

            InteractionManager.createGroup("player");
            InteractionManager.addToGroup(_player.body, "player");

            InteractionManager.createGroup("landscape");
            InteractionManager.addToGroup(_landscape.body, "landscape");

            InteractionManager.createGroup("objects");
            for each (var object:FlatEntity in _objects)
            {
                InteractionManager.addToGroup(object.body, "objects");
            }

            InteractionManager.createGroup("pad");
            InteractionManager.addToGroup(_pad.body, "pad");

            InteractionManager.createGroup("button");
            InteractionManager.addToGroup(_button.body, "button");

            InteractionManager.beginContact("player", "button", breakPentagon);
            InteractionManager.beginContact("player", "pad", bouncePlayer);
            InteractionManager.beginContact("player", "landscape", addRedGlow);
            InteractionManager.beginContact("player", "objects", addGreenGlow);
            InteractionManager.endContact("player", "landscape", removeGlow);
            InteractionManager.endContact("player", "objects", removeGlow);

            function breakPentagon():void
            {
                if (_pentagon.body)
                {
                    _pentagon.fracture(_pentagon.body.position, 5);
                }
            }

            function addRedGlow():void
            {
                _player.view.filter = BlurFilter.createGlow(0xFF0000);
            }

            function addGreenGlow():void
            {
                _player.view.filter = BlurFilter.createGlow(0x00FF00);
            }

            function removeGlow():void
            {
                _player.view.filter = null;
            }

            function bouncePlayer():void
            {
                _player.body.applyImpulse(new Vec2(0, -2000));
            }
        }
    }
}