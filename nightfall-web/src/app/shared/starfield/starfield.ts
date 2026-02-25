import {
    Component,
    ElementRef,
    AfterViewInit,
    OnDestroy,
    ViewChild,
    NgZone,
} from '@angular/core';

interface Star {
    x: number;
    y: number;
    size: number;
    speed: number;
}

@Component({
    selector: 'app-starfield',
    standalone: true,
    template: `<canvas #canvas></canvas>`,
    styleUrl: './starfield.css',
})
export class StarfieldComponent implements AfterViewInit, OnDestroy {
    @ViewChild('canvas', { static: true }) canvasRef!: ElementRef<HTMLCanvasElement>;

    private stars: Star[] = [];
    private animId = 0;
    private lastTime = 0;

    constructor(private ngZone: NgZone) { }

    ngAfterViewInit(): void {
        const canvas = this.canvasRef.nativeElement;
        this.resize(canvas);

        // Generate 55 pixel-square stars
        for (let i = 0; i < 55; i++) {
            this.stars.push({
                x: Math.random(),
                y: Math.random(),
                size: Math.random() > 0.5 ? 2 : 3,
                speed: 0.012 + Math.random() * 0.025,
            });
        }

        // Run outside Angular zone for performance
        this.ngZone.runOutsideAngular(() => {
            this.lastTime = performance.now();
            this.animate();
        });

        window.addEventListener('resize', this.onResize);
    }

    ngOnDestroy(): void {
        cancelAnimationFrame(this.animId);
        window.removeEventListener('resize', this.onResize);
    }

    private onResize = () => {
        this.resize(this.canvasRef.nativeElement);
    };

    private resize(canvas: HTMLCanvasElement): void {
        const dpr = window.devicePixelRatio || 1;
        canvas.width = window.innerWidth * dpr;
        canvas.height = window.innerHeight * dpr;
        const ctx = canvas.getContext('2d')!;
        ctx.scale(dpr, dpr);
    }

    private animate = (): void => {
        const now = performance.now();
        const dt = (now - this.lastTime) / 1000; // seconds
        this.lastTime = now;

        const canvas = this.canvasRef.nativeElement;
        const ctx = canvas.getContext('2d')!;
        const w = window.innerWidth;
        const h = window.innerHeight;

        // Background gradient: #1B263B → #000
        const grad = ctx.createLinearGradient(0, 0, 0, h);
        grad.addColorStop(0, '#1B263B');
        grad.addColorStop(1, '#000000');
        ctx.fillStyle = grad;
        ctx.fillRect(0, 0, w, h);

        // Draw stars
        ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
        for (const star of this.stars) {
            star.y += star.speed * dt;
            if (star.y > 1) star.y -= 1;
            ctx.fillRect(
                star.x * w,
                star.y * h,
                star.size,
                star.size
            );
        }

        this.animId = requestAnimationFrame(this.animate);
    };
}
