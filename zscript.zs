version 4.11

class HDDustFX : VisualThinker
{
	private double _RollSpeed;
	private double _Gravity;
	private double _Drag;
	private double _ScaleStep;
	private int _StartTime, _Lifetime;
	private double _StartAlpha;

	static HDDustFX Create(
		Vector3 pos,
		Vector2 scale,
		double scaleStep,
		Vector3 velRange,
		double rollRange,
		double gravity,
		double drag,
		double alpha,
		int lifetime
	)
	{
		double rollSpeed = FRandom[hddustfx](-rollRange, rollRange);
		let dust = HDDustFX(VisualThinker.Spawn(
			"HDDustFX",
			TexMan.CheckForTexture("RSMKA0"),
			pos,
			(FRandom(-velRange.X, velRange.X), FRandom(-velRange.Y, velRange.Y), FRandom(-velRange.Z, velRange.Z)),
			alpha,
			roll: rollSpeed * FRandom[hddustfx](0, 2),
			scale: scale,
			style: STYLE_SHADED
		));
		dust._ScaleStep = scaleStep;
		dust._Gravity = gravity;
		dust._Drag = drag;
		dust._RollSpeed = rollSpeed;
		Console.PrintF("lifetime: "..lifetime);
		dust._Lifetime = lifetime;

		return dust;
	}

	override void PostBeginPlay()
	{
		_StartTime = _Lifetime;
		_StartAlpha = Alpha;
		SColor = "#808080";
	}

	override void Tick()
	{
		if (_Lifetime <= 0)
		{
			Destroy();
			Console.PrintF("dead");
			return;
		}
		else
			--_Lifetime;

		// apply drag
		if (Vel.X > 0.0)
			Vel.X = max(0, Vel.X - _Drag);

		else if (Vel.X < 0.0)
			Vel.X = min(0, Vel.X + _Drag);

		if (Vel.Y > 0.0)
			Vel.Y = max(0, Vel.Y - _Drag);

		else if (Vel.Y < 0.0)
			Vel.Y = min(0, Vel.Y + _Drag);

		// gravity
		Vel.Z += _Gravity;

		Roll += _RollSpeed;
		Scale = (Scale.X + _ScaleStep, Scale.Y + _ScaleStep);
		Alpha = _StartAlpha * (_LifeTime / _StartTime);

		Super.Tick();
	}
}

class HDHitsparksHandler : EventHandler
{
	override void WorldThingSpawned(WorldEvent e)
	{
		if (!e.Thing)
			return;
		
		// in case you want to add more, just add more if statements lol
		if (HDBulletPuff(e.Thing))
		{
			let puff = HDBulletPuff(e.Thing);
			FSpawnParticleParams particle;
			particle.Texture = TexMan.CheckForTexture("rsmka0");
			particle.Style = STYLE_Shaded;
			particle.Flags = SPF_RELATIVE | SPF_ROLL | SPF_REPLACE;
			particle.Color1 = "#808080";

			// directions
			Vector2 angles = (-cos(puff.angle), -sin(puff.angle));
			double pitch = sin(puff.pitch);

			// because scale is sometimes negative
			Vector2 trueScale = (abs(puff.Scale.X), abs(puff.Scale.Y));

			// big smoke fog thing
			// very slow
			particle.Size = 30 * trueScale.X;
			for (int i = 0; i < 4; i++)
			{
				bool left = Random(True, False);

				// HDDustFX.Create(
				// 	e.Thing.Pos + (FRandom(-3, 3), FRandom(-3, 3), FRandom(-3, 3)),
				// 	(1 * trueScale.X, 1 * trueScale.Y),
				// 	FRandom(0.05, 0.08),
				// 	(FRandom(0, 0.2) * angles.X + 0.5, FRandom(0, 0.2) * angles.Y + 0.5, FRandom(0, 0.2) * pitch + 0.5),
				// 	0.00005,
				// 	-0.0025,
				// 	FRandom(0.025, 0.05),
				// 	FRandom(1, 1.5),
				// 	TICRATE * FRandom(8, 12) * trueScale.X
				// );
				particle.Lifetime = TICRATE * FRandom(8, 12) * trueScale.X;
				particle.Pos = e.Thing.Pos + (FRandom(-3, 3), FRandom(-3, 3), FRandom(-3, 3));
				particle.Vel = (FRandom(0, 0.2) * angles.x + FRandom(-0.5, 0.5), FRandom(0, 0.2) * angles.y + FRandom(-0.5, 0.5), FRandom(0, 0.2) * pitch + FRandom(-0.5, 0.5));
				particle.Accel = (0, 0, -0.0025);
				particle.StartAlpha = FRandom(1, 1.5);
				particle.FadeStep = -1;
				particle.SizeStep = FRandom(0.5, 0.8);
				particle.StartRoll = Random(90, 360);
				particle.RollVel = (left)? 0.5 : -0.5;
				particle.RollAcc = (left)? -0.001 : 0.001;

				Level.SpawnParticle(particle);
			}

			// smoke mid
			particle.Size = 20 * trueScale.X;
			for (int i = 0; i < 4; i++)
			{
				bool left = Random(True, False);

				particle.Lifetime = TICRATE * FRandom(3, 6) * trueScale.X;
				particle.Pos = e.Thing.Pos + (FRandom(-3, 3), FRandom(-3, 3), FRandom(-3, 3));
				particle.Vel = (FRandom(0, 0.5) * angles.x, FRandom(0, 0.5) * angles.y, FRandom(0, 0.5) * pitch);
				particle.Accel = (0, 0, -0.005);
				particle.StartAlpha = FRandom(1, 1.5);
				particle.FadeStep = -1;
				particle.SizeStep = FRandom(0.5, 0.8);
				particle.StartRoll = Random(90, 360);
				particle.RollVel = (left)? 0.5 : -0.5;
				particle.RollAcc = (left)? -0.001 : 0.001;

				Level.SpawnParticle(particle);
			}

			// small smoke
			particle.Size = 10 * trueScale.X;
			for (int i = 0; i < 4; i++)
			{
				bool left = Random(True, False);

				particle.Lifetime = TICRATE * FRandom(1, 3) * trueScale.X;
				particle.Pos = e.Thing.Pos + (FRandom(-3, 3), FRandom(-3, 3), FRandom(-3, 3));
				particle.Vel = (FRandom(0.5, 1.0) * angles.x, FRandom(0.5, 1.0) * angles.y, FRandom(0.5, 1.0) * pitch);
				particle.Accel = (0, 0, -0.005);
				particle.StartAlpha = FRandom(1.5, 2.5);
				particle.FadeStep = -1;
				particle.SizeStep = FRandom(0.5, 0.8);
				particle.StartRoll = Random(90, 360);
				particle.RollVel = (left)? 0.5 : -0.5;
				particle.RollAcc = (left)? -0.001 : 0.001;

				Level.SpawnParticle(particle);
			}
		}
		else if (HDExplosion(e.Thing))
		{
			let puff = HDExplosion(e.Thing);
			FSpawnParticleParams particle;
			particle.Texture = TexMan.CheckForTexture("rsmka0");
			particle.Style = STYLE_Shaded;
			particle.Flags = SPF_RELATIVE | SPF_ROLL | SPF_REPLACE;
			particle.Color1 = "#808080";

			Vector2 trueScale = (abs(puff.Scale.X), abs(puff.Scale.Y));

			// big smoke fog thing
			// very slow
			particle.Size = 50 * trueScale.X;
			for (int i = 0; i < 8; i++)
			{
				bool left = Random(True, False);

				particle.Lifetime = TICRATE * FRandom(8, 12) * trueScale.X;
				particle.Pos = e.Thing.Pos + (FRandom(-20, 20), FRandom(-20, 20), FRandom(-20, 20));
				particle.Vel = (FRandom(-0.5, 0.5), FRandom(-0.5, 0.5), FRandom(-0.5, 0.5));
				particle.Accel = (0, 0, -0.0025);
				particle.StartAlpha = FRandom(1, 1.5);
				particle.FadeStep = -1;
				particle.SizeStep = FRandom(0.5, 0.8);
				particle.StartRoll = Random(90, 360);
				particle.RollVel = (left)? 0.5 : -0.5;
				particle.RollAcc = (left)? -0.001 : 0.001;

				Level.SpawnParticle(particle);
			}

			// smoke mid
			particle.Size = 40 * trueScale.X;
			for (int i = 0; i < 8; i++)
			{
				bool left = Random(True, False);

				particle.Lifetime = TICRATE * FRandom(3, 6) * trueScale.X;
				particle.Pos = e.Thing.Pos + (FRandom(-25, 25), FRandom(-25, 25), FRandom(-25, 25));
				particle.Vel = (FRandom(-1.0, 1.0), FRandom(-1.0, 1.0), FRandom(-1.0, 1.0));
				particle.Accel = (0, 0, -0.005);
				particle.StartAlpha = FRandom(1, 1.5);
				particle.FadeStep = -1;
				particle.SizeStep = FRandom(0.5, 0.8);
				particle.StartRoll = Random(90, 360);
				particle.RollVel = (left)? 0.5 : -0.5;
				particle.RollAcc = (left)? -0.001 : 0.001;

				Level.SpawnParticle(particle);
			}
		}
	}
}
