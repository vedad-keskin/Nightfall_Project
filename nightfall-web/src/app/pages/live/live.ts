import { Component, inject, signal, computed } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LanguageService } from '../../shared/language/language.service';
import {
  LiveRankingService,
  RankedPlayer,
  PlayerAnalytics,
} from '../../shared/firebase/live-ranking.service';

interface RoleStats {
  roleId: number;
  roleName: string;
  played: number;
  won: number;
}

@Component({
  selector: 'app-live',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './live.html',
  styleUrl: './live.css',
})
export class LiveComponent {
  readonly ls = inject(LanguageService);
  readonly ranking = inject(LiveRankingService);

  codeInput = signal('');
  expandedPlayer = signal<string | null>(null);

  readonly players = this.ranking.players;
  readonly connected = this.ranking.connected;
  readonly hasSession = this.ranking.hasSession;
  readonly sessionCode = this.ranking.sessionCode;
  readonly error = this.ranking.error;

  onCodeInput(value: string): void {
    this.codeInput.set(value.toUpperCase().replace(/[^A-Z]/g, '').slice(0, 6));
  }

  connect(): void {
    const code = this.codeInput();
    if (code.length === 6) {
      this.ranking.connect(code);
    }
  }

  disconnect(): void {
    this.ranking.disconnect();
    this.codeInput.set('');
    this.expandedPlayer.set(null);
  }

  togglePlayer(id: string): void {
    this.expandedPlayer.update((c) => (c === id ? null : id));
  }

  isExpanded(id: string): boolean {
    return this.expandedPlayer() === id;
  }

  getRankColor(rank: number): string {
    if (rank === 1) return '#FFD700';
    if (rank === 2) return '#C0C0C0';
    if (rank === 3) return '#CD7F32';
    return '#E0E1DD';
  }

  getRankChange(player: RankedPlayer, currentRank: number): string {
    if (player.previousRank === undefined) return '';
    if (player.previousRank < currentRank) return 'down';
    if (player.previousRank > currentRank) return 'up';
    return '';
  }

  getTotalGames(player: RankedPlayer): number {
    return player.analytics.length;
  }

  getTotalWins(player: RankedPlayer): number {
    return player.analytics.filter((a) => a.won).length;
  }

  getWinRate(player: RankedPlayer): string {
    const total = this.getTotalGames(player);
    if (total === 0) return '0';
    return ((this.getTotalWins(player) / total) * 100).toFixed(0);
  }

  getAllianceGames(player: RankedPlayer, allianceId: number): number {
    return player.analytics.filter((a) => a.allianceId === allianceId).length;
  }

  getAllianceWins(player: RankedPlayer, allianceId: number): number {
    return player.analytics.filter(
      (a) => a.allianceId === allianceId && a.won,
    ).length;
  }

  getAlliancePct(player: RankedPlayer, allianceId: number): number {
    const games = this.getAllianceGames(player, allianceId);
    if (games === 0) return 0;
    return Math.round(
      (this.getAllianceWins(player, allianceId) / games) * 100,
    );
  }

  getAllianceColor(allianceId: number): string {
    if (allianceId === 1) return '#52B788';
    if (allianceId === 2) return '#E63946';
    if (allianceId === 3) return '#9D4EDD';
    return '#E0E1DD';
  }

  getRoleStats(player: RankedPlayer): RoleStats[] {
    const map = new Map<number, RoleStats>();
    for (const a of player.analytics) {
      if (!map.has(a.roleId)) {
        map.set(a.roleId, {
          roleId: a.roleId,
          roleName: a.roleName,
          played: 0,
          won: 0,
        });
      }
      const s = map.get(a.roleId)!;
      s.played++;
      if (a.won) s.won++;
    }
    return [...map.values()].sort((a, b) => b.played - a.played);
  }

  getRolePct(s: RoleStats): number {
    if (s.played === 0) return 0;
    return Math.round((s.won / s.played) * 100);
  }

  getRoleColor(roleId: number): string {
    const colors: Record<number, string> = {
      1: '#E0E1DD',
      2: '#E63946',
      3: '#4CAF50',
      4: '#FFD166',
      5: '#06D6A0',
      6: '#4CC9F0',
      7: '#E63946',
      8: '#E63946',
      9: '#9D4EDD',
      10: '#CD9777',
      11: '#9E2A2B',
      12: '#7209B7',
      13: '#6B4226',
      14: '#8E9B97',
      15: '#D4AF37',
      16: '#E8720C',
      17: '#6EC6CA',
      18: '#E63946',
    };
    return colors[roleId] ?? '#E0E1DD';
  }
}
