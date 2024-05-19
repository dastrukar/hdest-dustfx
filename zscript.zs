version 4.11

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
			for (int i = 0; i < 10; i++)
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
			for (int i = 0; i < 10; i++)
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
