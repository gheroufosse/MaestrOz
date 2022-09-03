% -*- coding: utf-8 -*-
%
% @Authors : G. Heroufosse, N. Degives
% @Creation Date: 04/22
% @File: code.oz

local
   CWD = '' % Put here the **absolute** path to the project files
   [Project] = {Link [CWD#'Project2022.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Returns the duration (in seconds) of a partition by adding the duration of each note/silence
   % If chord, take only the first note since a chord gathers several notes at the same time
   % Input: Part, a partition
    % Output : The duration of the partition in seconds

   fun {Length Part}
      fun {LengthA L Acc}
         case L of H|T then
            case H
            of drone(note:A amount:P) then
               {LengthA {Append {Drone A P} T} Acc}
            [] transpose(semitones:A P) then
               {LengthA {Append {Transpose A P} T} Acc}
            [] stretch(factor:A P) then
               {LengthA {Append {Stretch A P} T} Acc}
            [] duration(seconds:A P) then
               {LengthA {Append {Duration A P} T} Acc}
            [] X|Y then
               if X == nil then {LengthA T Acc}
               elseif {HasFeature X duration} then {LengthA T Acc+X.duration}
               else
                  {LengthA T Acc+1.0}
               end
            [] Atom#Octave then
               {LengthA T Acc+1.0}
            [] Atom then
               if {HasFeature H duration} then
                  {LengthA T Acc+H.duration}
               else
                  {LengthA T Acc+1.0}
               end
            end
         [] nil then Acc
         else
            0.0
         end
      end
   in
      {LengthA Part 0.0}
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Sets the duration of the partition to the specified number of seconds.
   % Adapts the duration of each note/silence according to the initial duration.
   % Inputs : Time : the time in seconds ; Part : the partition
   % Output : The partition (Part) adjusted to the time (Time)

   fun {Duration Time Part}
      local L in
         L={Length Part}
         {Stretch Time/L Part}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Stretch the duration of the partition by stretching each note by the factor Fact
   % Input : Stretch factor (Fact) and a partition to be stretched
   % Output : The stretched partition (each sound/silence is stretched)

   fun {Stretch Fact Part}
      local ToExt
         fun {StretchAux Fact Part}
            case Part
            of H|T then
               case H
               of note(name:A octave:B sharp:C duration:D instrument:E) then note(name:A octave:B sharp:C duration:D*Fact instrument:E) | {StretchAux Fact T} % Notes
                    [] X|Y then {StretchAux Fact H} | {StretchAux Fact T} % Chords
                    [] silence(duration:D) then silence(duration:D*Fact) | {StretchAux Fact T} % Silences
                    else nil
               end
            [] nil then nil
            end
         end
      in
         ToExt = {PartitionToTimedList Part}
         {StretchAux Fact ToExt}
      end
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Repeats the note a number (Amount) of times
   % Input : A note (Note) and a number of repetitions (Amount)
   % Output : A list with Amount times note

   fun {Drone Amount Note}
      fun {Addc Amount Acc}
         if Amount >= 1 then {Addc Amount-1 {Append Acc Note}}
         else Acc
         end
      end
   in
        {Addc Amount nil}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Transposes the notes a certain number of semitones up (positive) or down (negative)
   % Input : N the number of semitones of difference and note the note to transpose
   % Output : Semitone transfomer note

      fun {TransposeNotes N Notes}
       fun {TransposeNote Note Acc}
         case Note
            of H|T then [{TransposeNote H 0} {TransposeNote T 0}] % Chords
            [] nil then Note
         else
            if N>0 then
               if Acc<N then
                  case Note.name
                  of c then
                     if Note.sharp == false then {TransposeNote note(name:c octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc+1}
                     else {TransposeNote note(name:d octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                     end
                  [] d then
                     if Note.sharp == false then {TransposeNote note(name:d octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc+1}
                     else {TransposeNote note(name:e octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                     end
                  [] e then {TransposeNote note(name:f octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                  [] f then
                     if Note.sharp == false then {TransposeNote note(name:f octave:Note.octave sharp:true duration:Note.duration instrument : Note.instrument) Acc+1}
                     else {TransposeNote note(name:g octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                     end
                  [] g then
                     if Note.sharp == false then {TransposeNote note(name:g octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc+1}
                     else {TransposeNote note(name:a octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                     end
                  [] a then
                     if Note.sharp == false then {TransposeNote note(name:a octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc+1}
                     else {TransposeNote note(name:b octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                     end
                  [] b then {TransposeNote note(name:c octave:Note.octave+1 sharp:false duration:Note.duration instrument:Note.instrument) Acc+1}
                  else Note
                  end
               else Note
               end
            elseif N<0 then
               if Acc>N then
                  case Note.name
                  of b then {TransposeNote note(name:a octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc-1}
                  [] a then
                     if Note.sharp==true then {TransposeNote note(name:a octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     else {TransposeNote note(name:g octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc-1}
                     end
                  [] g then
                     if Note.sharp==true then {TransposeNote note(name:g octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     else {TransposeNote note(name:f octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc-1}
                     end
                  [] f then
                     if Note.sharp==true then {TransposeNote note(name:f octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     else {TransposeNote note(name:e octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     end
                  [] e then {TransposeNote note(name:d octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc-1}
                  [] d then
                     if Note.sharp==true then {TransposeNote note(name:d octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     else {TransposeNote note(name:c octave:Note.octave sharp:true duration:Note.duration instrument:Note.instrument) Acc-1}
                     end
                  [] c then
                     if Note.sharp==true then {TransposeNote note(name:c octave:Note.octave sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     else {TransposeNote note(name:b octave:Note.octave-1 sharp:false duration:Note.duration instrument:Note.instrument) Acc-1}
                     end
                     else Note
                  end
               else Note
               end
            end
         end
      end
    in {TransposeNote Notes 0}
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Take a partition and transpose each note with the desired step
   % Input : the partition and the step by which you want to move each note
   % Output : Transformed partition
   fun {Transpose Semitones Part}
      case Part
      of H|T then
         case H
         of Note then
                {TransposeNotes Semitones {NoteToExtended H}} | {Transpose Semitones T}
         [] note(name:A octave:B sharp:C duration:D instrument:E) then
                {TransposeNotes Semitones note(name:A octave:B sharp:C duration:D instrument:E)} | {Transpose Semitones T}
         [] silence(duration:D) then
                H|{Transpose Semitones T}
         else
                {Transpose Semitones {NoteToExtended H}}|{Transpose Semitones T}
         end
      else nil
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Translate a note to the extended notation ; and a Chord to an Extended Chord

   fun {NoteToExtended Note}
      case Note
        of H|T then {NoteToExtended H}|{NoteToExtended T}
        [] nil then nil
      [] Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] note(name:A octave:B sharp:C duration:D instrument:E) then note(name:A octave:B sharp:C duration:D instrument:E)
      [] silence(duration:D) then silence(duration:D)
      [] Atom then
         if {HasFeature Atom duration} then Atom
         else
            case {AtomToString Atom}
            of [_] then
               note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
            [] [N O] then
               note(name:{StringToAtom [N]}
                  octave:{StringToInt [O]}
                  sharp:false
                  duration:1.0
                  instrument:none)
                else
                    silence(duration:1.0)
            end
         end
      end
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Take a partition with notes, silences and associated transformations
    % Output : Return a list with all transformations applied and extended notes/chords.

   fun {PartitionToTimedList Partition}
      fun {Aux Partition Acc}
         case Partition
         of H|T then
            case H
            of duration(seconds:A P) then {Aux T {Append Acc {Duration A P}}}
            [] stretch(factor:A P) then {Aux T {Append Acc {Stretch A P}}}
            [] drone(note:Note amount:Amount) then {Aux T {Append Acc {Drone Amount {Aux [Note] nil}}}}
            [] transpose(semitones:N P) then {Aux T {Append Acc {Transpose N P}}}
            [] silence(duration:D) then {Aux T {Append Acc [{NoteToExtended H}]}}
            [] Note then {Aux T {Append Acc [{NoteToExtended H}]}}
            [] note(name:A octave:B sharp:C duration:D instrument:E) then {Aux T {Append Acc [note(name:A octave:B sharp:C duration:D instrument:E)]}}
            [] Name#Octave then {Aux T {Append Acc [{NoteToExtended H}]}}
                [] X|Y then {Aux T {Append Acc {NoteToExtended H}}}
         %   [] X|Y then if {HasFeature X duration} then {Aux T {Append Acc H}}
          %          else {Aux Y {Append Acc {NoteToExtended X}}}|{Aux T Acc}
           %         end
            else {Aux T Acc}
            end
         else Acc
         end
      end
   in
      {Aux Partition nil}
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input: Take an Extended note
    % Output : Return the height in comparison to A4

   fun {Hauteur Note}
      local Oct N in
         Oct = {IntToFloat Note.octave} - 4.0
         case Note.name
         of c then
            if Note.sharp then N=~8.0
            else N=~9.0
            end
         [] d then
            if Note.sharp then N=~6.0
            else N=~7.0
            end
         [] e then
            N=~5.0
         [] f then
            if Note.sharp then N=~3.0
            else N=~4.0
	    		end
   	 	[] g then
	       	if Note.sharp then N=~1.0
	       	else N=~2.0
	    	   end
   	 	[] a then
	       	if Note.sharp then N=1.0
	       	else N=0.0
	    	   end
         [] b then N=2.0
	    	end
	 	   12.0 * Oct + N
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : extended note
   % Output : return the associated frequence

   fun {Freq Note}
      {Pow 2.0 {Hauteur Note}/12.0}*440.0
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Input : Extended note to be transformed in frequences samples
   % Output : Returns a long list of 44100 samples * the duration of the note corresponds to the frequency variation of the note

   fun {Samples Note}
      local Pi
         fun {SamplesAux N Acc}
            case N
            of silence(duration:D) then
               if Acc =< 44100.0*N.duration then
                  0.0 | {SamplesAux N Acc+1.0}
               else nil
               end
            else
               if Acc =< 44100.0*N.duration then
                  0.5*({Sin (2.0*Pi*{Freq N}*Acc)/44100.0}) |  {SamplesAux N Acc+1.0}
               else
                  nil
               end
            end
         end
      in
         Pi = 3.141592653
         {SamplesAux Note 0.0}
      end
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Take a partition to be transformed in a sequence of samples
   % Output : Transforms the entire partition into samples using the Sample function described earlier, proceeding note/chord by note

   fun {PartitionToSample Fonc Part}
      local ToExt
         fun {PartitionToSampleAux Part}
            case Part
		      of H|T then
			      case H
			      of X|Y then
				      {Append {Chord2Sample H} {PartitionToSampleAux T}}
			      [] nil then nil
			      else
                  	{Append {Samples H} {PartitionToSampleAux T}}
			      end
		      else nil
		      end
         end
      in
         ToExt = {Fonc Part}
         {PartitionToSampleAux ToExt}
      end
   end


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Take a chord to be transform in samples
    % Output : Mean of the frequences for the whole chord

   fun {Chord2Sample Chord}
      case Chord
      of H|nil then {Samples H}
      [] H|T then
         {Mean {Samples H} {Chord2Sample T}}
      else nil
      end
   end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Take two lists of the same size
	% Output : Return the mean of the two lists, element by element
	fun {Mean X Y}
	   case X of H|nil then
			(H+Y.1)/2.0|nil
		[] H|T then
			(H+Y.1)/2.0|{Mean T Y.2}
		else nil
		end
	end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : list of musics (each with its intensities) to be played in the same time
    % Output : Sum of the musics with associated intensities

    fun {Merge Musics}
       case Musics
       of H|nil then
          case H of I#M then {Map {Mix PartitionToTimedList M} fun {$ A} A*I end}
          end
       [] H|T then case H
          of I#M then {Add {Map {Mix PartitionToTimedList M} fun {$ A} A*I end} {Merge T}}
          end
       end
    end



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : relative path to a .wav file (string)
   % Output : list of samples of the .wav file

   fun {Wave File}
        local F in
            F={Project.load File}
        {Mix PartitionToTimedList F}
        end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : Music : a list of sample
   % Output : The reversed music. It reverses the order of the samples
   fun {Reverse Music}
        local M in
            M={Mix PartitionToTimedList Music}
        {List.reverse M}
        end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Music to be repeated a certain amount of time
    % Output : List with n amount of the same music
   fun {Repeat Amount Music}
      local M
         fun {RepeatA Amount Music Acc}
            if Amount > 0 then {RepeatA Amount-1 Music {Append Acc Music}}
            else Acc
            end
         end
        in
            M={Mix PartitionToTimedList Music}
        {RepeatA Amount M nil}
        end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : Time over which to play a song
   % Output : The music played in loop on the time of the duration. The last repetition is truncated to not exceed the duration
    % This function is not completly working.
   fun {Loop Duration Music}
      local M
         fun {LoopN Duration Music N}
            if N=< {FloatToInt Duration*44100.0} then
               case Music
                    of H|nil then H|{LoopN Duration Music N+1}
                    [] H|T then H|{LoopN Duration T N+1}
                    else nil
               end
            else nil
            end
         end
      in
         M={Mix PartitionToTimedList Music}
         {LoopN Duration M 1}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : A transformed music with frequences ; Low and High boundaries
    % Output : Return a music with frequences limited between the given boudaries
   fun {Clip Low High Music}
        local
            M = {Mix PartitionToTimedList Music}
            fun {ClipA N}
                if N>High then High
                elseif N<Low then Low
                else N
                end
            end
        in
            {Map M ClipA}
        end
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Input : Two list with same length or not
   % Output : Sum of the two list, completed by 0 when size are differents

   fun {Add L1 L2}
      if {List.length L1} \= {List.length L2} then
        if {List.length L1} > {List.length L2} then {Add L1 {Append L2 {Map {List.number 1 ({List.length L1}-{List.length L2}) 1} fun {$ A} {IntToFloat A*0} end}}}
        else {Add L2 {Append L1 {Map {List.number 1 ({List.length L2}-{List.length L1}) 1} fun {$ A} {IntToFloat A*0} end}}}
        end
      else {Sum L1 L2}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : two lists of the same size
    % Outpu : Sum of the two list, element by element

   fun{Sum X Y}
      case X
      of H|nil then
         H+Y.1|nil
      [] H|T then
         H+Y.1|{Sum T Y.2}
      else
         nil
      end
  end



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Music with a delay in seconds and a decay factor
    % Output : Return the sum of the music and its echo, with delay and a smaller intensity


   fun {Echo Delay Decay Music}
      local E in
         E = {Append {Map {List.number 1 {FloatToInt Delay*44100.0} 1} fun {$ A} {IntToFloat A*0} end} {Mix PartitionToTimedList Music}}
         {Add {Map E fun {$ A} A*Decay end} {Mix PartitionToTimedList Music}}
      end
   end



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Music is a list of samples, start time and out time (in seconds)
    % Output : Return a music with increasing intensity at the start and decreasing at the end, defined by the start and out boundaries
   fun {Fade Start Out Music}
      local Deb P1 Fin P3 P2 M in
         M = {Mix PartitionToTimedList Music}
         Deb = {List.take M {FloatToInt (44100.0*Start)}}
         P1 = {List.mapInd Deb fun{$ I A} A*1.0/(Start*44100.0)*{IntToFloat (I-1)} end}
         Fin = {List.drop M {FloatToInt {IntToFloat {List.length M}}-(Out*44100.0)}}
         P3 = {List.mapInd Fin fun {$ I A} A*(1.0-(1.0/(Out*44100.0))*{IntToFloat I}) end}
         P2 = {List.take {List.drop M {FloatToInt Start*44100.0}} {List.length M}-{FloatToInt Start*44100.0}-{FloatToInt Out*44100.0}}
         {Append {Append P1 P2} P3}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Start and Out are float, Music is a list of sample
    % Output : Cut the music between Start and Finish boundaries
	fun {Cut Start Finish Music}
        local M in M={Mix PartitionToTimedList Music}
            {List.take {List.drop M {FloatToInt Start*44100.0}} {FloatToInt {IntToFloat {List.length M}}-Finish*44100.0}}
        end
    end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input : Take a function P2T that transform the Music in a list of notes/chords
    % Output : return a list of samples

   fun {Mix P2T Music}
	   case Music
	   of H|T then
		   case H
         of samples(P) then
            {Append P {Mix P2T T}}
         [] partition(P) then
            {Append {PartitionToSample P2T P} {Mix P2T T}}
         [] wave(P) then
            {Append {Wave P} {Mix P2T T}}
         [] merge(P) then
            {Append {Merge P} {Mix P2T T}}
         [] reverse(P) then
            {Append {Reverse P} {Mix P2T T}}
         [] repeat(amount:A P) then
            {Append {Repeat A P} {Mix P2T T}}
         [] loop(seconds:A P) then
            {Append {Loop A P} {Mix P2T T}}
         [] clip(low:A high:B P) then
            {Append {Clip A B P} {Mix P2T T}}
         [] echo(delay:T decay:A P) then
            {Append {Echo T A P} {Mix P2T T}}
         [] fade(start:A out:B P) then
            {Append {Fade A B P} {Mix P2T T}}
         [] cut(start:A finish:B P) then
            {Append {Cut A B P} {Mix P2T T}}
         else
            nil
         end
      else
         nil
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   Music = {Project.load CWD#'CodeLyokoz.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   % !!! Remove this before submitting.
in
   Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   {ForAll [NoteToExtended Music Samples PartitionToSample Merge Stretch Length] Wait}

   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   {Browse {Project.run Mix PartitionToTimedList Music 'echo.wav'}}

   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end
