CREATE TABLE [dbo].[Dwarf] (
    [Id]     INT           NOT NULL,
    [Name]   NVARCHAR (50) NULL,
    [IdCave] INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Dwarf_Cave] FOREIGN KEY ([IdCave]) REFERENCES [dbo].[Cave] ([Id])
);

